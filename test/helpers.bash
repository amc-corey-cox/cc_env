# Shared sandbox for characterization tests.
# Builds a fake HOME with copies of the repo dotfiles, fake nvm/pyenv installs,
# and runs real bash shells under `env -i` so nothing leaks from the host.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GOLDEN_DIR="$REPO_ROOT/test/golden"
BASE_PATH=/usr/local/bin:/usr/bin:/bin

make_exe() {
  mkdir -p "$(dirname "$1")"
  printf '#!/bin/sh\necho %s\n' "$2" > "$1"
  chmod +x "$1"
}

make_venv() {
  make_exe "$1/bin/python" "$2"
  printf 'VIRTUAL_ENV="%s"\nexport VIRTUAL_ENV\ndeactivate() { unset VIRTUAL_ENV; }\n' "$1" > "$1/bin/activate"
}

make_repo() {
  mkdir -p "$1"
  git -C "$1" init -q -b "${2:-main}"
  git -C "$1" commit -q --allow-empty -m init
  echo .venv >> "$1/.git/info/exclude"
}

setup_sandbox() {
  export SANDBOX_HOME="$BATS_TEST_TMPDIR/home"
  mkdir -p "$SANDBOX_HOME/.bash.d"
  cp "$REPO_ROOT/.bashrc" "$REPO_ROOT/.bash_init" "$REPO_ROOT/.profile" "$SANDBOX_HOME/"
  cp "$REPO_ROOT"/.bash.d/.bash_* "$SANDBOX_HOME/.bash.d/"
  # .bashrc hardcodes BASHD=/home/corey/.bash.d (see interactive.bats); point it at the sandbox
  sed -i "s|^BASHD=/home/corey/.bash.d$|BASHD=\"\$HOME/.bash.d\"|" "$SANDBOX_HOME/.bashrc"

  # Silences the Ubuntu /etc/bash.bashrc sudo hint in interactive shells
  touch "$SANDBOX_HOME/.sudo_as_admin_successful"
  printf '[user]\n\tname = Test\n\temail = test@example.com\n[init]\n\tdefaultBranch = main\n' > "$SANDBOX_HOME/.gitconfig"
  export GIT_CONFIG_GLOBAL="$SANDBOX_HOME/.gitconfig" GIT_CONFIG_NOSYSTEM=1

  local v
  for v in v18.20.3 v20.11.1 v22.1.0 v22.12.0; do
    make_exe "$SANDBOX_HOME/.nvm/versions/node/$v/bin/node" "$v"
  done
  mkdir -p "$SANDBOX_HOME/.nvm/alias/lts"
  echo "lts/hydrogen" > "$SANDBOX_HOME/.nvm/alias/default"
  echo "v18.20.3" > "$SANDBOX_HOME/.nvm/alias/lts/hydrogen"

  make_exe "$SANDBOX_HOME/.pyenv/shims/python" "pyenv-python"
  mkdir -p "$SANDBOX_HOME/.pyenv/bin"
}

# Non-interactive shell as used by scripts and Claude Code: bash -c with BASH_ENV
_init_shell() {
  cd "$1" && shift
  env -i HOME="$SANDBOX_HOME" PATH="$BASE_PATH" BASH_ENV="$SANDBOX_HOME/.bash_init" "$@" bash -c "$CMD"
}
run_init() { run _init_shell "$@"; echo "$output"; }

# Interactive terminal shell: bash -i reads .bashrc
_interactive_shell() {
  cd "$1" && shift
  env -i HOME="$SANDBOX_HOME" PATH="$BASE_PATH" TERM=xterm-256color LANG=C.UTF-8 "$@" bash -i -c "$CMD" 2>/dev/null
}
run_interactive() { run _interactive_shell "$@"; echo "$output"; }

# Render PS1 exactly as bash expands it, with host-specific bits normalized.
# First arg is the exit status of the previous command.
render_ps1() {
  local rc="$1" dir="$2"; shift 2
  CMD="(exit $rc); printf '%s' \"\${PS1@P}\"" run_interactive "$dir" "$@"
  output="${output//"$(id -un)@$(hostname -s)"/USER@HOST}"
}

strip_ansi() {
  printf '%s' "$1" | sed -e $'s/\x1b\\][^\x07]*\x07//g' -e $'s/\x1b\\[[0-9;]*m//g' -e $'s/[\x01\x02]//g'
}

# Compare visible form of $output with a golden file; UPDATE_GOLDENS=1 writes it instead
assert_golden() {
  local file="$GOLDEN_DIR/$1.txt" actual
  actual="$(printf '%s' "$output" | cat -v)"
  if [[ -n "${UPDATE_GOLDENS:-}" ]]; then
    mkdir -p "$GOLDEN_DIR"
    printf '%s\n' "$actual" > "$file"
    return
  fi
  [[ -f "$file" ]] || { echo "missing golden: $file"; return 1; }
  diff -u "$file" <(printf '%s\n' "$actual")
}

path_has_no_dupes() {
  local dupes
  dupes="$(tr ':' '\n' <<< "$1" | sort | uniq -d)"
  [[ -z "$dupes" ]] || { echo "duplicate PATH entries: $dupes"; return 1; }
}

make_named_venv() {
  make_venv "$1" "$2"
  printf 'home = /usr/bin\nname = %s\n' "$2" > "$1/pyvenv.cfg"
}

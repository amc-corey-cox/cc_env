# Non-interactive shells (scripts, Claude Code): bash -c with BASH_ENV=.bash_init

load helpers

setup() {
  setup_sandbox
  H="$SANDBOX_HOME"
  TOOLS_PATH="$H/.local/share/mise/shims:$H/.pyenv/bin:$H/.pyenv/shims"
  CMD='echo "$PATH"; echo "VE=${VIRTUAL_ENV:-}"; command -v node || echo "node=none"; python'
}

nvm_node() { echo "$H/.nvm/versions/node/$1/bin"; }

@test "no venv, no .nvmrc: tool shims only, pyenv python" {
  mkdir -p "$H/proj"
  run_init "$H/proj"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$TOOLS_PATH:$BASE_PATH" ]
  [ "${lines[1]}" = "VE=" ]
  [ "${lines[3]}" = "pyenv-python" ]
}

@test "nvm default alias lts/hydrogen is not followed to its version" {
  mkdir -p "$H/proj"
  run_init "$H/proj"
  [[ "${lines[0]}" != *"/.nvm/"* ]]
  [[ "${lines[2]}" != "$H"/* ]]
}

@test "nvm default alias with a numeric version: newest match, behind mise and pyenv" {
  echo 22 > "$H/.nvm/alias/default"
  mkdir -p "$H/proj"
  run_init "$H/proj"
  [ "${lines[0]}" = "$TOOLS_PATH:$(nvm_node v22.12.0):$BASE_PATH" ]
  [ "${lines[2]}" = "$(nvm_node v22.12.0)/node" ]
}

@test "venv: .venv/bin only" {
  make_venv "$H/proj/.venv" proj-venv
  run_init "$H/proj"
  [ "${lines[0]}" = "$H/proj/.venv/bin:$TOOLS_PATH:$BASE_PATH" ]
  [ "${lines[1]}" = "VE=$H/proj/.venv" ]
  [ "${lines[3]}" = "proj-venv" ]
}

@test "venv: .venv/uv-venv/bin only" {
  mkdir -p "$H/proj/.venv"
  make_venv "$H/proj/.venv/uv-venv" proj-uv
  run_init "$H/proj"
  [ "${lines[0]}" = "$H/proj/.venv/uv-venv/bin:$TOOLS_PATH:$BASE_PATH" ]
  [ "${lines[1]}" = "VE=$H/proj/.venv/uv-venv" ]
  [ "${lines[3]}" = "proj-uv" ]
}

@test "venv: both layouts present, uv-venv wins (activate_venv prefers .venv/bin)" {
  make_venv "$H/proj/.venv" proj-venv
  make_venv "$H/proj/.venv/uv-venv" proj-uv
  run_init "$H/proj"
  [ "${lines[1]}" = "VE=$H/proj/.venv/uv-venv" ]
  [ "${lines[3]}" = "proj-uv" ]
}

@test "venv: found in a parent directory" {
  make_venv "$H/work/.venv" work-venv
  mkdir -p "$H/work/proj/src"
  run_init "$H/work/proj/src"
  [ "${lines[1]}" = "VE=$H/work/.venv" ]
  [ "${lines[3]}" = "work-venv" ]
}

@test "venv: nearest one wins over a parent's" {
  make_venv "$H/work/.venv" work-venv
  make_venv "$H/work/proj/.venv" proj-venv
  run_init "$H/work/proj"
  [ "${lines[1]}" = "VE=$H/work/proj/.venv" ]
  [ "${lines[3]}" = "proj-venv" ]
}

@test ".nvmrc: major version picks newest install" {
  mkdir -p "$H/proj"; echo 22 > "$H/proj/.nvmrc"
  run_init "$H/proj"
  [ "${lines[2]}" = "$(nvm_node v22.12.0)/node" ]
}

@test ".nvmrc: v-prefixed minor version" {
  mkdir -p "$H/proj"; echo v22.1 > "$H/proj/.nvmrc"
  run_init "$H/proj"
  [ "${lines[2]}" = "$(nvm_node v22.1.0)/node" ]
}

@test ".nvmrc: full version with CRLF and surrounding whitespace" {
  mkdir -p "$H/proj"; printf ' 20.11.1 \r\n' > "$H/proj/.nvmrc"
  run_init "$H/proj"
  [ "${lines[2]}" = "$(nvm_node v20.11.1)/node" ]
}

@test ".nvmrc: lts/* is skipped and stops the search" {
  mkdir -p "$H/work/proj"
  echo 20 > "$H/work/.nvmrc"
  echo 'lts/*' > "$H/work/proj/.nvmrc"
  run_init "$H/work/proj"
  [[ "${lines[0]}" != *"/.nvm/"* ]]
}

@test ".nvmrc: version not installed adds nothing" {
  mkdir -p "$H/proj"; echo 16 > "$H/proj/.nvmrc"
  run_init "$H/proj"
  [[ "${lines[0]}" != *"/.nvm/"* ]]
}

@test ".nvmrc: nearest file wins" {
  mkdir -p "$H/work/proj"
  echo 18 > "$H/work/.nvmrc"
  echo 20 > "$H/work/proj/.nvmrc"
  run_init "$H/work/proj"
  [ "${lines[2]}" = "$(nvm_node v20.11.1)/node" ]
  run_init "$H/work"
  [ "${lines[2]}" = "$(nvm_node v18.20.3)/node" ]
}

@test "PATH order: .nvmrc node, venv, mise/pyenv, default node" {
  echo 18 > "$H/.nvm/alias/default"
  make_venv "$H/proj/.venv" proj-venv
  echo 22 > "$H/proj/.nvmrc"
  run_init "$H/proj"
  [ "${lines[0]}" = "$(nvm_node v22.12.0):$H/proj/.venv/bin:$TOOLS_PATH:$(nvm_node v18.20.3):$BASE_PATH" ]
}

@test "nested shells keep PATH free of duplicates" {
  echo 18 > "$H/.nvm/alias/default"
  make_venv "$H/proj/.venv" proj-venv
  echo 22 > "$H/proj/.nvmrc"
  run_init "$H/proj"
  local outer="${lines[0]}"
  CMD='bash -c "bash -c '\''echo \$PATH'\''"' run_init "$H/proj"
  [ "$output" = "$outer" ]
  path_has_no_dupes "$output"
}

@test "UV_VENV_DIR is exported and UV_PROJECT_ENVIRONMENT is not" {
  mkdir -p "$H/proj"
  CMD='echo "${UV_VENV_DIR-unset} ${UV_PROJECT_ENVIRONMENT-unset}"' run_init "$H/proj"
  [ "$output" = ".venv/uv-venv unset" ]
}

# Debian's bash treats a socket on stdin as an ssh session: it reads .bashrc
# (which returns early for non-interactive shells) and skips BASH_ENV.
_socket_stdin_shell() {
  cd "$1" && python3 -c '
import os, socket, sys
a, b = socket.socketpair()
os.dup2(a.fileno(), 0)
os.execvp("env", ["env", "-i"] + sys.argv[1:])
' HOME="$SANDBOX_HOME" PATH="$BASE_PATH" BASH_ENV="$SANDBOX_HOME/.bash_init" bash -c 'echo "VE=${VIRTUAL_ENV:-}"'
}

@test "socket on stdin: bash -c skips BASH_ENV, so no venv activation" {
  make_venv "$H/proj/.venv" proj-venv
  run _socket_stdin_shell "$H/proj"
  echo "$output"
  [ "$output" = "VE=" ]
}

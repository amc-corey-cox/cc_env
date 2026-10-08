# Interactive terminal shells: bash -i reads .bashrc and everything in .bash.d

load helpers

setup() {
  setup_sandbox
  H="$SANDBOX_HOME"
  TOOLS_PATH="$H/.local/share/mise/shims:$H/.pyenv/bin:$H/.pyenv/shims"
}

@test "PATH has tool shims once, though .bash_paths is sourced twice" {
  mkdir -p "$H/proj"
  CMD='echo "$PATH"' run_interactive "$H/proj"
  [ "$output" = "$TOOLS_PATH:$BASE_PATH" ]
}

@test "venv is not auto-activated in interactive shells" {
  make_venv "$H/proj/.venv" proj-venv
  CMD='echo "VE=${VIRTUAL_ENV:-}"; python' run_interactive "$H/proj"
  [ "${lines[0]}" = "VE=" ]
  [ "${lines[1]}" = "pyenv-python" ]
}

@test ".bashrc exports BASH_ENV pointing at .bash_init" {
  mkdir -p "$H/proj"
  CMD='bash -c "echo \$BASH_ENV"' run_interactive "$H/proj"
  [ "$output" = "$H/.bash_init" ]
}

@test ".bashrc loads .bash.d from \$HOME" {
  CMD='type -t color_git_venv activate_venv' run_interactive "$H"
  [ "${lines[0]}" = "function" ]
  [ "${lines[1]}" = "function" ]
}

@test "rm is blocked in interactive shells" {
  CMD='rm -f x; echo "status=$?"' run_interactive "$H"
  [ "${lines[0]}" = "Use 'trash' instead of 'rm'." ]
  [ "${lines[2]}" = "status=1" ]
}

@test "activate_venv: .venv/bin only" {
  make_venv "$H/proj/.venv" proj-venv
  mkdir -p "$H/proj/sub"
  CMD='activate_venv; echo "VE=$VIRTUAL_ENV"' run_interactive "$H/proj/sub"
  [ "${lines[0]}" = "Activating the virtual environment at $H/proj/.venv." ]
  [ "${lines[1]}" = "VE=$H/proj/.venv" ]
}

@test "activate_venv: .venv/uv-venv only" {
  mkdir -p "$H/proj/.venv"
  make_venv "$H/proj/.venv/uv-venv" proj-uv
  CMD='activate_venv; echo "VE=$VIRTUAL_ENV"' run_interactive "$H/proj"
  [ "${lines[1]}" = "VE=$H/proj/.venv/uv-venv" ]
}

@test "activate_venv: both layouts present, .venv/bin wins (.bash_init prefers uv-venv)" {
  make_venv "$H/proj/.venv" proj-venv
  make_venv "$H/proj/.venv/uv-venv" proj-uv
  CMD='activate_venv; echo "VE=$VIRTUAL_ENV"' run_interactive "$H/proj"
  [ "${lines[1]}" = "VE=$H/proj/.venv" ]
}

@test "activate_venv: no venv" {
  mkdir -p "$H/proj"
  CMD='activate_venv; echo "status=$?"' run_interactive "$H/proj"
  [ "${lines[0]}" = "No virtual environment found, could not activate." ]
  [ "${lines[1]}" = "status=1" ]
}

@test "activate_venv: .venv without an activate script" {
  mkdir -p "$H/proj/.venv"
  CMD='activate_venv; echo "status=$?"' run_interactive "$H/proj"
  [ "${lines[0]}" = "No activation script found in $H/proj/.venv" ]
  [ "${lines[1]}" = "status=1" ]
}

@test "activate_venv: already active" {
  make_venv "$H/proj/.venv" proj-venv
  CMD='activate_venv; echo "status=$?"' run_interactive "$H/proj" VIRTUAL_ENV="$H/proj/.venv"
  [ "${lines[0]}" = "Virtual environment already active, run deactivate" ]
  [ "${lines[1]}" = "status=2" ]
}

@test "activate_venv: switches from a different active venv" {
  make_venv "$H/other/.venv" other-venv
  make_venv "$H/proj/.venv" proj-venv
  CMD='source "$HOME/other/.venv/bin/activate"; cd "$HOME/proj"; activate_venv; echo "VE=$VIRTUAL_ENV"' run_interactive "$H/proj"
  [ "${lines[0]}" = "Different virtual environment active, deactivating..." ]
  [ "${lines[2]}" = "VE=$H/proj/.venv" ]
}

_login_shell() {
  cd "$1" && env -i HOME="$SANDBOX_HOME" PATH="$BASE_PATH" bash -l -c 'echo "$PATH"; echo "$BASH_ENV"; echo "VE=${VIRTUAL_ENV:-}"'
}

@test "login shell: .profile puts ~/.local/bin ahead of everything" {
  mkdir -p "$H/.local/bin"
  run _login_shell "$H"
  [[ "${lines[0]}" == "$H/.local/bin:$TOOLS_PATH:$BASE_PATH"* ]]
  [ "${lines[1]}" = "$H/.bash_init" ]
}

@test "non-interactive login shell also runs .bash_init via the BASH_ENV .profile exports" {
  make_venv "$H/proj/.venv" proj-venv
  run _login_shell "$H/proj"
  [[ "${lines[0]}" == "$H/proj/.venv/bin:$TOOLS_PATH:"* ]]
  [ "${lines[2]}" = "VE=$H/proj/.venv" ]
}

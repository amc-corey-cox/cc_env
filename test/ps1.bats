# Rendered prompt for each venv / git / exit-status state.
# Every state is rendered twice with different fixture data, each against its own
# golden file, and the visible text must contain the fixture-specific names.
# Goldens record pre-refactor behavior; regenerate only with explicit approval:
#   UPDATE_GOLDENS=1 bats test/ps1.bats

load helpers

setup() {
  setup_sandbox
  H="$SANDBOX_HOME"
}

# ps1_case GOLDEN STATUS DIR [VAR=value...]; sets $plain to the visible prompt text
ps1_case() {
  local golden="$1"; shift
  render_ps1 "$@"
  [ "$status" -eq 0 ]
  assert_golden "$golden"
  plain="$(strip_ansi "$output")"
  echo "plain: $plain"
}

@test "venv active and correct: (name) in green" {
  make_repo "$H/alpha-proj" feat-a
  make_named_venv "$H/alpha-proj/.venv" alpha
  ps1_case ps1_venv_active_1 0 "$H/alpha-proj" VIRTUAL_ENV="$H/alpha-proj/.venv"
  [[ "$plain" == *" (alpha) "* ]]
  [[ "$output" == *$'\e[01;32m\002(alpha)'* ]]

  make_repo "$H/code/beta-proj" fix-b
  make_named_venv "$H/code/beta-proj/.venv" beta-env
  mkdir -p "$H/code/beta-proj/src"
  ps1_case ps1_venv_active_2 0 "$H/code/beta-proj/src" VIRTUAL_ENV="$H/code/beta-proj/.venv"
  [[ "$plain" == *" (beta-env) "* ]]
}

@test "venv active but not the project's: !!active ≠ project!! in red" {
  make_repo "$H/alpha-proj" feat-a
  make_named_venv "$H/alpha-proj/.venv" alpha
  make_named_venv "$H/envs/gamma" gamma
  ps1_case ps1_venv_wrong_1 0 "$H/alpha-proj" VIRTUAL_ENV="$H/envs/gamma"
  [[ "$plain" == *"!!gamma ≠ alpha!!"* ]]
  [[ "$output" == *$'\e[01;31m\002!!gamma'* ]]

  make_repo "$H/beta-proj" fix-b
  make_named_venv "$H/beta-proj/.venv" beta-env
  make_named_venv "$H/envs/delta" delta-env
  ps1_case ps1_venv_wrong_2 0 "$H/beta-proj" VIRTUAL_ENV="$H/envs/delta"
  [[ "$plain" == *"!!delta-env ≠ beta-env!!"* ]]
}

@test "venv inactive, inside the repo: *name* in yellow" {
  make_repo "$H/alpha-proj" feat-a
  make_named_venv "$H/alpha-proj/.venv" alpha
  ps1_case ps1_venv_inactive_repo_1 0 "$H/alpha-proj"
  [[ "$plain" == *" *alpha* "* ]]
  [[ "$output" == *$'\e[0;33m\002*alpha*'* ]]

  make_repo "$H/beta-proj" fix-b
  make_named_venv "$H/beta-proj/.venv" beta-env
  mkdir -p "$H/beta-proj/pkg"
  ps1_case ps1_venv_inactive_repo_2 0 "$H/beta-proj/pkg"
  [[ "$plain" == *" *beta-env* "* ]]
}

@test "venv inactive, in a parent outside the repo: +name+ in yellow" {
  make_named_venv "$H/work/.venv" workenv
  make_repo "$H/work/alpha-proj" feat-a
  ps1_case ps1_venv_inactive_parent_1 0 "$H/work/alpha-proj"
  [[ "$plain" == *" +workenv+ "* ]]
  [[ "$output" == *$'\e[0;33m\002+workenv+'* ]]

  make_named_venv "$H/area/.venv" area-env
  mkdir -p "$H/area/plain-dir"
  ps1_case ps1_venv_inactive_parent_2 0 "$H/area/plain-dir"
  [[ "$plain" == *" +area-env+ "* ]]
}

@test "venv active with no project venv: -name- in cyan" {
  make_named_venv "$H/envs/gamma" gamma
  make_repo "$H/alpha-proj" feat-a
  ps1_case ps1_venv_outside_1 0 "$H/alpha-proj" VIRTUAL_ENV="$H/envs/gamma"
  [[ "$plain" == *" -gamma- "* ]]
  [[ "$output" == *$'\e[01;36m\002-gamma-'* ]]

  make_named_venv "$H/envs/delta" delta-env
  mkdir -p "$H/scratch"
  ps1_case ps1_venv_outside_2 0 "$H/scratch" VIRTUAL_ENV="$H/envs/delta"
  [[ "$plain" == *" -delta-env- "* ]]
}

@test "venv name: pyvenv.cfg name is kept when uv-venv sits inside .venv" {
  make_repo "$H/alpha-proj" feat-a
  make_named_venv "$H/alpha-proj/.venv" alpha
  make_venv "$H/alpha-proj/.venv/uv-venv" uvpy
  ps1_case ps1_name_uv_inactive_1 0 "$H/alpha-proj"
  [[ "$plain" == *" *alpha* "* ]]

  make_repo "$H/beta-proj" fix-b
  make_named_venv "$H/beta-proj/.venv" beta-env
  make_venv "$H/beta-proj/.venv/uv-venv" uvpy
  ps1_case ps1_name_uv_inactive_2 0 "$H/beta-proj"
  [[ "$plain" == *" *beta-env* "* ]]
}

@test "venv name: uv-venv active shows as wrong venv (uv-venv ≠ hand name)" {
  make_repo "$H/alpha-proj" feat-a
  make_named_venv "$H/alpha-proj/.venv" alpha
  make_venv "$H/alpha-proj/.venv/uv-venv" uvpy
  ps1_case ps1_name_uv_active_1 0 "$H/alpha-proj" VIRTUAL_ENV="$H/alpha-proj/.venv/uv-venv"
  [[ "$plain" == *"!!uv-venv ≠ alpha!!"* ]]

  make_repo "$H/beta-proj" fix-b
  make_named_venv "$H/beta-proj/.venv" beta-env
  make_venv "$H/beta-proj/.venv/uv-venv" uvpy
  ps1_case ps1_name_uv_active_2 0 "$H/beta-proj" VIRTUAL_ENV="$H/beta-proj/.venv/uv-venv"
  [[ "$plain" == *"!!uv-venv ≠ beta-env!!"* ]]
}

@test "venv name: venv_name.txt fallback" {
  make_repo "$H/alpha-proj" feat-a
  make_venv "$H/alpha-proj/.venv" x
  echo " txt-alpha " > "$H/alpha-proj/.venv/venv_name.txt"
  ps1_case ps1_name_txt_1 0 "$H/alpha-proj"
  [[ "$plain" == *" *txt-alpha* "* ]]

  make_repo "$H/beta-proj" fix-b
  make_venv "$H/beta-proj/.venv" x
  printf 'home = /usr/bin\n' > "$H/beta-proj/.venv/pyvenv.cfg"
  echo "txt-beta" > "$H/beta-proj/.venv/venv_name.txt"
  ps1_case ps1_name_txt_2 0 "$H/beta-proj"
  [[ "$plain" == *" *txt-beta* "* ]]
}

@test "venv name: basename fallback" {
  make_repo "$H/alpha-proj" feat-a
  make_venv "$H/alpha-proj/.venv" x
  ps1_case ps1_name_basename_1 0 "$H/alpha-proj"
  [[ "$plain" == *" *.venv* "* ]]

  make_named_venv "$H/envs/plainvenv" x
  printf 'home = /usr/bin\n' > "$H/envs/plainvenv/pyvenv.cfg"
  mkdir -p "$H/scratch"
  ps1_case ps1_name_basename_2 0 "$H/scratch" VIRTUAL_ENV="$H/envs/plainvenv"
  [[ "$plain" == *" -plainvenv- "* ]]
}

@test "git: main and master are red (inverse)" {
  make_repo "$H/alpha-proj" main
  ps1_case ps1_git_main_1 0 "$H/alpha-proj"
  [[ "$plain" == *"~/alpha-proj (main) \$ " ]]
  [[ "$output" == *$'\e[07;31m\002(main)'* ]]

  make_repo "$H/beta-proj" master
  touch "$H/beta-proj/dirty"
  ps1_case ps1_git_main_2 0 "$H/beta-proj"
  [[ "$plain" == *"~/beta-proj (master) \$ " ]]
  [[ "$output" == *$'\e[07;31m\002(master)'* ]]
}

@test "git: dirty feature branch is cyan" {
  make_repo "$H/alpha-proj" feat-a
  touch "$H/alpha-proj/untracked"
  ps1_case ps1_git_dirty_1 0 "$H/alpha-proj"
  [[ "$plain" == *"~/alpha-proj (feat-a) \$ " ]]
  [[ "$output" == *$'\e[0;36m\002(feat-a)'* ]]

  make_repo "$H/beta-proj" topic/fix-b
  echo x > "$H/beta-proj/f"; git -C "$H/beta-proj" add f; git -C "$H/beta-proj" commit -qm f
  echo y > "$H/beta-proj/f"
  ps1_case ps1_git_dirty_2 0 "$H/beta-proj"
  [[ "$plain" == *"~/beta-proj (topic/fix-b) \$ " ]]
  [[ "$output" == *$'\e[0;36m\002(topic/fix-b)'* ]]
}

@test "git: clean feature branch is green" {
  make_repo "$H/alpha-proj" feat-a
  ps1_case ps1_git_clean_1 0 "$H/alpha-proj"
  [[ "$plain" == *"~/alpha-proj (feat-a) \$ " ]]
  [[ "$output" == *$'\e[0;32m\002(feat-a)'* ]]

  make_repo "$H/beta-proj" release-2
  mkdir -p "$H/beta-proj/docs"
  ps1_case ps1_git_clean_2 0 "$H/beta-proj/docs"
  [[ "$plain" == *"~/beta-proj/docs (release-2) \$ " ]]
}

@test "no git, no venv: bare prompt" {
  mkdir -p "$H/alpha-dir"
  ps1_case ps1_bare_1 0 "$H/alpha-dir"
  [[ "$plain" == " ✔ USER@HOST:~/alpha-dir \$ " ]]

  mkdir -p "$H/beta/dir"
  ps1_case ps1_bare_2 0 "$H/beta/dir"
  [[ "$plain" == " ✔ USER@HOST:~/beta/dir \$ " ]]
}

@test "exit status: ✔ in green after success, ✘ in red after failure" {
  mkdir -p "$H/alpha-dir"
  ps1_case ps1_status_fail_1 1 "$H/alpha-dir"
  [[ "$plain" == " ✘ USER@HOST:~/alpha-dir \$ " ]]
  [[ "$output" == *$'\e[01;31m\002✘'* ]]

  mkdir -p "$H/beta-dir"
  ps1_case ps1_status_fail_2 127 "$H/beta-dir"
  [[ "$plain" == " ✘ USER@HOST:~/beta-dir \$ " ]]

  ps1_case ps1_status_ok 0 "$H/beta-dir"
  [[ "$output" == *$'\e[01;32m\002✔'* ]]
}

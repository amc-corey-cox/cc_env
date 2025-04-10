# !/bin/bash
# Set up custom alliaces for bash profile
# Source from .bashrc

# Additional functions related to the PS1 variable are in .bash.d/.bash_ps1

### Functions for managing Python venv virtual environments ###

# Find the root of the vevn virtual environment
function get_venv_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.venv" ]; then
      echo -e "$dir/.venv"
      return
    fi
    dir=$(dirname "$dir")
  done
}

# Create an activate function to locate current repository venv and activate it.
function activate() {
  local base_venv_root="$(get_venv_root)"
  if [[ "${base_venv_root}" == "" ]]; then
    echo -e "No virtual environment found, could not activate."
    return 1
  else
    local venv_root="$base_venv_root"
    if [[ ! -f "$base_venv_root/bin/activate" ]]; then
      if [[ -f "$base_venv_root/uv-venv/bin/activate" ]]; then
        venv_root="$base_venv_root/uv-venv"
      else
        echo -e "No activation script found in $base_venv_root"
        return 1
      fi
    fi

    if [[ -n "$VIRTUAL_ENV" ]]; then
      if [[ "$VIRTUAL_ENV" == "${venv_root}" ]]; then
        echo -e "Virtual environment already active, run deactive"
        return 2
      else
        echo -e "Different virtual environment active, deactivating..."
        deactivate
      fi
    fi
    echo -e "Activating the virtual environment at ${venv_root}."
    source "${venv_root}/bin/activate"
  fi
}


### Other custom bash functions here ###

# Use trash instead of rm to reduce accidental deletions
function rm() {
    echo "Use 'trash' instead of 'rm'."
    echo "To use 'rm', use '\rm' or 'command rm'."
    return 1
}


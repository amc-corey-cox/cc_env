# !/bin/bash
# Set up custom alliaces for bash profile
# Source from .bashrc

# Additional functions related to the PS1 variable are in .bash.d/.bash_ps1

### Functions for managing Python venv virtual environments ###

# Generic function to find the root for environment management
function get_root() {
  local name="$1"
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    if [[ -e "$dir/$name" ]]; then
      echo -e "$dir"
      return
    fi
    dir=$(dirname "$dir")
  done
}

# Find the root of the mise and uv virtual environment
function get_mise_root() {
  local mise_root
  mise_root=$(get_root "mise.local.toml")
  if [[ -z "$mise_root" ]]; then
    mise_root=$(get_root "mise.toml")
  fi
  echo "$mise_root"
}

# Find the root of the venv virtual environment
function get_venv_root() {
  local venv_root=$(get_root ".venv")
  echo -e "$venv_root/.venv"
}

# Activate function to activate either mise and uv or venv if present.
function activate() {
  local mise_root=$(get_mise_root)

  if [[ -n "$mise_root" ]]; then
    echo -e "Activating mise and uv from $mise_root"
    REPO_ENV_ACTIVATING=1 bash --rcfile ~/.bashrc
  else
    local venv_root=$(get_venv_root)
    if [[ -n "$venv_root" ]]; then
      activate_venv
    else
      echo "No development environment found to activate."
    fi
  fi
}

# Create an activate function to locate current repository venv and activate it.
function activate_venv() {
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
        echo -e "Virtual environment already active, run deactivate"
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


### Mange nested shell for mise and uv activation ###

# Activation function for mise and uv in nested shell
function activate_mise_uv() {
  local mise_root=$(get_mise_root)

  if [[ ":$PATH:" != *":$MISE_PATH:"* ]]; then
    export PATH="$MISE_PATH:$PATH"
  fi

  if [[ -n "$mise_root" ]]; then
    echo -e "Configuring tools via mise from $mise_root/ for mise.local.toml or mise.toml"
    mise activate || return $?

    echo -e "Setting up Python virtual environment via uv"
    uv sync || return $?

    # set up auto completions if in interactive shell
    if [[ $- == *i* ]]; then
      source <(mise completions bash)
      eval "$(uv generate-shell-completion bash)"
    fi
  else
    echo -e "No mise configuration found, skipping mise and uv activation."
  fi
}

# In nested shell, activate mise and uv
if [[ -n "$REPO_ENV_ACTIVATING" ]]; then
  unset REPO_ENV_ACTIVATING
  if [[ -n "$REPO_ENV_ACTIVE" ]]; then
    echo "Environment already active."
    return
  fi

  export REPO_ENV_ACTIVE=1

  #Print a message if the user exits manually
  trap 'echo -e "Exiting mise and uv nested shell."' EXIT

  # Activate mise and uv for environment management
  activate_mise_uv || {
    echo -e "Failed to activate mise and uv environment."
    exit 1
  }
  echo -e "Nested shell for mise and uv activated. Use 'deactivate' to exit."

  # Replace the deactivate function to close the nested shell
  deactivate() {
    exit 0
  }
fi
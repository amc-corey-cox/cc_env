#!/bin/bash
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
  echo -e "$(get_root ".venv")/.venv"
}

# Activate function to activate either mise and uv or venv if present.
function activate() {
  local mise_root=$(get_mise_root)

  if [[ -n "$mise_root" ]]; then
    echo -e "Setting up uv in $mise_root"
    uv sync || return $?
    eval "$(uv generate-shell-completion bash)"
  fi

  local venv_root=$(get_venv_root)
  if [[ -n "$venv_root" ]]; then
    activate_venv
  else
    echo "No development environment found to activate."
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

# Use trash instead of rm to reduce accidental deletions, only if interactive shell
if [[ $- == *i* ]]; then
  function rm() {
    echo "Use 'trash' instead of 'rm'."
    echo "To use 'rm', use '\rm' or 'command rm'."
    return 1
  }
fi

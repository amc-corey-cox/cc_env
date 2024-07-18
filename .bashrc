# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Path to extra bashrc source files
BASHD=/home/corey/.bash.d

# import all files from .bash.d
# includes alliaces, path, and ps1
if [[ -d "${BASHD}" ]]; then
  for f in "$BASHD"/.bash_*; do
    if [[ -r $f ]]; then
      . $f
    fi
  done
  unset BASHD f 
fi

# if PATH is blank set PATH to default environment PATH
if [[ $PATH == "" ]]; then
  . /etc/environment
fi

# if a .bash_aliases file also exists source it
# most alliases are kept in .bash.d/.bash_alliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Use nvm to manage node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use pyenv to manage Python versions
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Create an activate function to locate current repository venv and activate it.
function activate() {
  local venv_root="$(get_venv_root)"
  if [[ "${venv_root}" == "" ]]; then
    echo -e "No virtual environment found, could not activate."
    return 1
  else
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


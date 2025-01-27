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
if [[ -z $PATH ]]; then
  . /etc/environment
fi

# If essential directories are missing warn and leave a sane working environment
for dir in /bin /usr/bin; do
  if ! [[ ":$PATH:" == *":$dir:"* ]]; then
    echo "Warning: $dir was missing from path and added! Check config files."
    export PATH="$PATH:$dir"
  fi
done
unset dir

# if a .bash_aliases file also exists source it
# most alliases are kept in .bash.d/.bash_alliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


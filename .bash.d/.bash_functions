# !/bin/bash
# Set up custom alliaces for bash profile
# Source from .bashrc

# Additional functions related to the PS1 variable are in .bash.d/.bash_ps1

###  My custom bash functions here ###

function rm() {
    echo "Use 'trash' instead of 'rm'."
    echo "To use 'rm', use '\rm' or 'command rm'."
    return 1
}


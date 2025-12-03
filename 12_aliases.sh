#!/usr/bin/env bash

# Prepare environment
set -eu

# Variables
ALIASES_FILENAME="$HOME/.dbc_aliases"
VARIABLES_FILENAME="$HOME/.dbc_variables"

# Functions
title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

# Main loop

if [[ ! -f ${ALIASES_FILENAME} ]]; then

    cat << EOF >> ${ALIASES_FILENAME}
# --
# dbc-setup-user-shell
# --
# ---
# My ls replacement
# ---
if [ -x "$(command -v exa)" ]; then
        alias l="exa --tree --level 2"
        alias ll="exa --long --tree --all --level 2 --group-directories-first --group --header --octal-permissions --no-permissions --extended"
else
        if [ -x "$(command -v tree)" ]; then
                alias l='pwd; tree -L 1 -CF --dirsfirst'
                alias ll='pwd; tree -L 1 -augshCDFp --dirsfirst'
                alias ll='pwd; tree -L 1 -augshCDFp --dirsfirst'
        fi
fi
# ---
# My cat replacement
# ---
if [ -x "$(command -v batcat)" ]; then
        alias less=batcat
        alias cat='batcat'
fi

## Neovim
alias n=nvim
alias sn='sudo nvim'

## nnn
alias nnn='nnn -d'
EOF
fi

if [[ ! -f ${VARIABLES_FILENAME} ]]; then
    cat << EOF >> ${VARIABLES_FILENAME}
# --
# nnn
# --
export NNN_OPENER="nuke"
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview;i:ipinfo'
EOF
fi

CHECK_IF_ALIASES_IN_ZSHRC=$(grep 'echo "source ${ALIASES_FILENAME}"' .zshrc | wc -l)
if [[ ${CHECK_IF_ALIASES_IN_ZSHRC} -eq 0 ]]; then
    echo "" >> $HOME/.zshrc
    echo "# ---" >> $HOME/.zshrc
    echo "# dbc-setup-user-shell" >> $HOME/.zshrc
    echo "# ---" >> $HOME/.zshrc
    echo "source ${ALIASES_FILENAME}" >> $HOME/.zshrc
fi
CHECK_IF_VARIABLES_IN_ZSHRC=$(grep 'echo "source ${ALIASES_FILENAME}"' .zshrc | wc -l)
if [[ ${CHECK_IF_VARIABLES_IN_ZSHRC} -eq 0 ]]; then
    echo "" >> $HOME/.zshrc
    echo "# ---" >> $HOME/.zshrc
    echo "# dbc-setup-user-shell" >> $HOME/.zshrc
    echo "# ---" >> $HOME/.zshrc
    echo "source ${VARIABLES_FILENAME}" >> $HOME/.zshrc
fi

title "Finished!"
echo ""

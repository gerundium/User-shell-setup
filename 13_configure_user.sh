#!/usr/bin/env bash
set -eu

# Variables
SSH_DIRECTORY="$HOME/.ssh"
ZSH_CONFIG_FILE="$HOME/.zshrc"
TESTUSER_ENABLE_FILE="/tmp/00_install.tmp"

# Functions
title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

# Main loop

# Preflight check
if [ "$EUID" -eq 0 ]
  then echo "Please run as user"
  exit
fi

title "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Prepare users HOME
cd $HOME

# Create ssh directory
if [[ ! -d "$SSH_DIRECTORY" ]]; then
  mkdir $HOME/.ssh
  chmod 0750 $HOME/.ssh
fi

# Create zsh config backup
if [[ ! -f "${ZSH_CONFIG_FILE}.bak" ]]; then
  cp .zshrc{,.bak}
fi

# Configure oh-my-zsh
sed -i -e 's/plugins=(git)/plugins=(git alias-finder branch colorize copypath direnv dirhistory extract kubectl rsync sudo ssh-agent universalarchive virtualenv)/g' -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="gnzh"/g' ${ZSH_CONFIG_FILE}
# Add custom aliases
echo "" >> ${ZSH_CONFIG_FILE}
echo "source $HOME/.dbc_aliases" >> ${ZSH_CONFIG_FILE}
# Change shell to zsh
if [[ -f "${TESTUSER_ENABLE_FILE}" ]]; then
  echo "test" | chsh -s $(which zsh)
else
  chsh -s $(which zsh)
fi

title "Finished! Please, restart your shell."
echo ""

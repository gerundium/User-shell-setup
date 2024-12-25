#!/usr/bin/env bash

# Prepare environment
set -eu

# Variables
TESTUSER_ENABLE_FILE="/tmp/00_install.tmp"

# Functions
title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

# Main loop

## Install packages
title "Enable Epel repo"
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled crb
dnf install epel-release -y

title "Install pip and Ansible"
dnf install -y \
    bat \
    util-linux-user \
    git \
    pip \
    sudo \
    tree \
    vim \
    zsh
python3 -m pip install --user ansible

## Configuration
title "Configuration"

### Install test user
if [[ -f "${TESTUSER_ENABLE_FILE}" ]]; then
    echo "test ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
    ### quietly add a user without password
    adduser --shell /bin/bash --home /home/test test
    ### set password
    echo "test:test" | chpasswd
fi

title "Finished!"
echo ""

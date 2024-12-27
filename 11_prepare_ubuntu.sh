#!/usr/bin/env bash

# Prepare environment
set -eu

# Variables

# Functions
title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

# Main loop

## Install packages
title "Install packages"
apt update && apt install \
    bat \
    curl \
    git \
    pip \
    python3 \
    software-properties-common \
    sudo \
    tree \
    vim \
    zsh \
    -y
ln -s /usr/bin/python3 /usr/bin/python

title "Configuration"
## Install test user
if [[ -f "${TESTUSER_ENABLE_FILE}" ]]; then
    echo "test ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
    # quietly add a user without password
    adduser --quiet --disabled-password --shell /bin/bash --home /home/test --gecos "User" test
    # set password
    echo "test:test" | chpasswd
fi

title "Finished!"
echo ""

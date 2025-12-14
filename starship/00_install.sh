#!/usr/bin/env bash

# Prepare environment
set -eu
trap ctrl_c INT
INSTALL_DIR=$(dirname "$(readlink -f "$0")")
PATH_TO_SCRIPT="$0"
source ${INSTALL_DIR}/.functions
source ${INSTALL_DIR}/.variables

# Main loop

## 1. Info next steps
info_next_steps

## 2. Install packages
install_packages

## 3. Prepare user setup
choose_user

## 4. User setup
sudo -iu $USERNAME_NEW bash -c "export INSTALL_DIR=$(dirname "$(readlink -f "$0")"); source ${INSTALL_DIR}/.functions; source ${INSTALL_DIR}/.variables; setup_user_environment"

## 5. Finish
title "Finished!"
echo ""

exit 0
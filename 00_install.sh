#!/usr/bin/env bash

# Prepare environment
set -eu

# Variables
RELEASE=$(grep ID_LIKE /etc/*elease | cut -d '"' -f2)
OS_DEBIAN=$(echo ${RELEASE} | grep -o debian | wc -l)
OS_RHEL=$(echo ${RELEASE} | grep -o rhel | wc -l)
TESTUSER_ENABLE_FILE="/tmp/00_install.tmp"
BASE_DIR=$(dirname $0)

# Functions
title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

# Main loop

## Install Test user
read -p "Install a test user for demonstration purpose? [y/N] " TESTUSER_ENABLE
if [[ ${TESTUSER_ENABLE} == "y" ]]; then
    touch ${TESTUSER_ENABLE_FILE}
else
    ## Choose user
    read -p "Whats the username of the user that will be configured for oh-my-zsh? " USERNAME_OMZSH
    if [[ -z $USERNAME_OMZSH ]]; then
        echo "[info]: You does not specify a username. Therefore the is nothing to do. Bye"
        exit 0
    fi
    getent passwd ${USERNAME_OMZSH} > /dev/null
    if [[ $? -ne 0 ]]; then
        echo "[CRIT]: Sorry user ${USERNAME_OMZSH} does not exist."
        exit 1
    fi
fi

## Run OS specific install process
if [[ ${OS_DEBIAN} -eq 1 ]]; then
    cd $BASE_DIR
    bash 11_prepare_ubuntu.sh
elif [[ ${OS_RHEL} -eq 1 ]]; then
    cd $BASE_DIR
    bash 11_prepare_rhel.sh
else
    echo "[WARN]: Sorry your OS is currently not supported."
    exit 1
fi


if [[ ${TESTUSER_ENABLE} == "y" ]]; then
    title "Running 12_aliases.sh for user test"
    su -c "cd $BASE_DIR; bash 12_aliases.sh" - test
    title "Running 13_configure_user.sh for user test"
    su -c "cd $BASE_DIR; bash 13_configure_user.sh" - test
else
    title "Running 12_aliases.sh for user ${USERNAME_OMZSH}"
    su -c "cd $BASE_DIR; bash 12_aliases.sh" - ${USERNAME_OMZSH}
    title "Running 13_configure_user.sh for user ${USERNAME_OMZSH}"
    su -c "cd $BASE_DIR; bash 13_configure_user.sh" - ${USERNAME_OMZSH}
fi

cd $BASE_DIR; bash 14_housekeeping.sh

title "Finished!"
echo ""

#!/usr/bin/env bash
set -eu

# Variables
TESTUSER_ENABLE_FILE="/tmp/00_install.tmp"

# Main loop 
## Housekeeping
if [[ -f "${TESTUSER_ENABLE_FILE}" ]]; then
    rm -f ${TESTUSER_ENABLE_FILE}
fi

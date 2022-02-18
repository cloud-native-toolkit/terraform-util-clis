#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
#---------------------------------------------------------------------------------------------

#
# Bash script to install the Azure CLI
#
SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

_TTY=/dev/tty

install_script="${SCRIPT_DIR}/azure_cli_install.py"

python_cmd=python3
if ! command -v python3 >/dev/null 2>&1
then
  if command -v python >/dev/null 2>&1
  then
    python_cmd=python
  else
    echo "ERROR: python3 or python not found."
    echo "If python is available on the system, add it to PATH."
    exit 1
  fi
fi

chmod 775 $install_script
echo "Running install script."
$python_cmd $install_script < $_TTY

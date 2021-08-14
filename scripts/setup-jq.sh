#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64

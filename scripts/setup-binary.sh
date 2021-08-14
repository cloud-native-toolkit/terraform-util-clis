#!/usr/bin/env bash

DEST_DIR="$1"
CLI_NAME="$2"
CLI_URL="$3"

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

COMMAND=$(command -v "${CLI_NAME}")

if [[ -n "${COMMAND}" ]]; then
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  if [[ -f "${BIN_DIR}/${CLI_NAME}.tmp" ]]; then
    echo "${CLI_NAME} is already being installed. Waiting..."

    while [[ -f "${BIN_DIR}/${CLI_NAME}.tmp" ]]; do
      sleep 10
    done
  else
    echo "${CLI_NAME} missing. Installing..."
    touch "${BIN_DIR}/${CLI_NAME}.tmp"

    curl -sLo "${BIN_DIR}/${CLI_NAME}.tmp" "${CLI_URL}"

    chmod +x "${BIN_DIR}/${CLI_NAME}.tmp"
    mv "${BIN_DIR}/${CLI_NAME}.tmp" "${BIN_DIR}/${CLI_NAME}"
  fi

  COMMAND="${BIN_DIR}/${CLI_NAME}"
fi

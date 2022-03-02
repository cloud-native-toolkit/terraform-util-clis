#!/usr/bin/env bash

DEST_DIR="$1"
CLI_NAME="$2"
CLI_URL="$3"

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  exit 0
fi

COMMAND=$(command -v "${CLI_NAME}")

if [[ -n "${COMMAND}" ]]; then
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  TMP_FILE="${BIN_DIR}/${CLI_NAME}.tmp"

  if [[ -f "${TMP_FILE}" ]]; then
    while [[ -f "${TMP_FILE}" ]]; do
      sleep 10
    done
  else
    touch "${TMP_FILE}"

    curl -sLo "${TMP_FILE}" "${CLI_URL}"

    if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
      cp "${TMP_FILE}" "${BIN_DIR}/${CLI_NAME}"
    fi

    rm "${TMP_FILE}"
    chmod +x "${BIN_DIR}/${CLI_NAME}"
  fi

  COMMAND="${BIN_DIR}/${CLI_NAME}"
fi

#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
export CLI_NAME="$2"
VERSION_MATCH="$3"

function debug() {
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  debug "CLI already provided in bin_dir"
  exit 0
fi

if command -v "${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  COMMAND=$(command -v "${CLI_NAME}")
fi

if [[ -n "${COMMAND}" ]] && [[ -n "${VERSION_MATCH}" ]]; then
  VERSION=$("${COMMAND}" --version | sed -E 's/[^0-9]*([0-9]+[.][0-9]+[.]?[0-9]*).*/\1/g')

  MAJOR=$(echo "${VERSION}" | sed -E 's/([0-9]+)[.]([0-9]+).*/\1/g')
  MINOR=$(echo "${VERSION}" | sed -E 's/([0-9]+)[.]([0-9]+).*/\2/g')

  MATCH_MAJOR=$(echo "${VERSION_MATCH}" | sed -E 's/([0-9]+)[.]([0-9]+).*/\1/g')
  MATCH_MINOR=$(echo "${VERSION_MATCH}" | sed -E 's/([0-9]+)[.]([0-9]+).*/\2/g')

  if [[ "${MAJOR}" -lt "${MATCH_MAJOR}" ]]; then
    debug "Old version of cli found in path: ${VERSION}"
    exit 1
  elif [[ "${MAJOR}" -eq "${MATCH_MAJOR}" ]] && [[ "${MINOR}" -lt "${MATCH_MINOR}" ]]; then
    debug "Old version of cli found in path: ${VERSION}"
    exit 1
  else
    debug "Recent version of cli found in path: ${VERSION}"
  fi
fi

if [[ -n "${COMMAND}" ]]; then
  debug "CLI already available in PATH. Creating symlink in ${BIN_DIR}"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
else
  exit 1
fi

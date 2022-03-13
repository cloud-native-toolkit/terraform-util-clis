#!/usr/bin/env bash

DEST_DIR="$1"
CLI_NAMES="$2"
CLI_URL="$3"
CLI_PATHS="$4"

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

IFS=';'
read -r -a cli_names <<< "${CLI_NAMES}"
read -r -a cli_paths <<< "${CLI_PATHS}"

if command -v "${BIN_DIR}/${cli_names[0]}" 1> /dev/null 2> /dev/null; then
  exit 0
fi

for cli_name in "${cli_names[@]}"; do
  command=$(command -v "${cli_name}" 2> /dev/null)

  if [[ -n "${command}" ]]; then
    ln -s "${command}" "${BIN_DIR}/${cli_name}"
  fi
done

if ! command -v "${BIN_DIR}/${cli_names[0]}" 1> /dev/null 2> /dev/null; then
  TAR_FILE="${BIN_DIR}/${cli_names[0]}.tgz"

  if [[ -f "${TAR_FILE}" ]]; then
    while [[ -f "${TAR_FILE}" ]]; do
      sleep 10
    done
  else
    touch "${TAR_FILE}"

    curl -sLo "${TAR_FILE}" "${CLI_URL}"

    for index in "${!cli_names[@]}"; do
      if [[ ! -f "${BIN_DIR}/${cli_names[$index]}" ]]; then
        cli_name="${cli_names[$index]}"
        cli_path="${cli_paths[$index]}"
        tar xzf "${TAR_FILE}" "${cli_path}"

        cp "${cli_path}" "${BIN_DIR}/${cli_name}"
        chmod +x "${BIN_DIR}/${cli_name}"
        rm "${cli_path}"
      fi
    done

    rm "${TAR_FILE}"
  fi
fi

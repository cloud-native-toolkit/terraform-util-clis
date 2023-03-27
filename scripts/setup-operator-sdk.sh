#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

CLI_NAME="operator-sdk"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

RELEASE=$(curl -s "https://api.github.com/repos/operator-framework/operator-sdk/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name // empty')

if [[ -z "${RELEASE}" ]]; then
  echo "operator-sdk release not found" >&2
  exit 1
fi


export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
export OS=$(uname | awk '{print tolower($0)}')

FILENAME="operator-sdk_${OS}_${ARCH}"

URL="https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE}/${FILENAME}"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" operator-sdk version

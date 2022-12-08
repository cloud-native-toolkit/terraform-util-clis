#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"
CLI_NAME="igc"

MIN_VERSION="1.42"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}" "${MIN_VERSION}"; then
  exit 0
fi

RELEASE=$(curl -sI "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${RELEASE}" ]]; then
  echo "igc release not found" >&2
  exit 1
fi

if [[ "${ARCH}" == "amd64" ]]; then
  "${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/download/${RELEASE}/igc-${TYPE}" --version "${MIN_VERSION}"
else
  "${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/download/${RELEASE}/igc-${TYPE}-${ARCH}" --version "${MIN_VERSION}"
fi
#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="mac"
fi

URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-${FILETYPE}.tar.gz"

echo "Getting kubectl from ${URL}"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" kubectl "${URL}" kubectl

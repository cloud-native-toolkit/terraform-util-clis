#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-${ARCH}"
if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" argocd "${URL}" "version --client"

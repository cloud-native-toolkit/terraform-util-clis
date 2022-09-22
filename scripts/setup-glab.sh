#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH_BASE="$3"

CLI_NAME="glab"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

ARCH=""
case "${ARCH_BASE}" in
    386)     ARCH="i386" ;;
    amd64)   ARCH="x86_64" ;;
    *)       ARCH="${ARCH_BASE}" ;;
esac

RELEASE=$(curl -sI "https://github.com/profclems/glab/releases/latest" | grep "location:" | sed -E "s~.*/tag/~~g")

if [[ -z "${RELEASE}" ]]; then
  echo "glab release not found" >&2
  exit 1
fi

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="glab_${SHORT_RELEASE}_Linux_${ARCH}"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="glab_${SHORT_RELEASE}_macOS_${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/profclems/glab/releases/download/${RELEASE}/${FILENAME}.tar.gz" "bin/glab" --version

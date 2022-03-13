#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="mac"
fi

URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-${FILETYPE}.tar.gz"

CMD_NAME="oc;kubectl"
if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  CMD_NAME="oc-bin;kubectl-bin"
fi

"${SCRIPT_DIR}/setup-binaries-from-tgz.sh" "${DEST_DIR}" "${CMD_NAME}" "${URL}" "oc;kubectl"

if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  echo "/lib/ld-musl-x86_64.so.1 --library-path /lib ${DEST_DIR}/oc-bin \$@" > "${DEST_DIR}/oc"
  chmod +x "${DEST_DIR}/oc"

  echo "/lib/ld-musl-x86_64.so.1 --library-path /lib ${DEST_DIR}/kubectl-bin \$@" > "${DEST_DIR}/kubectl"
  chmod +x "${DEST_DIR}/kubectl"
fi

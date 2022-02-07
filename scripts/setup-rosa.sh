SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

CLI_NAME="rosa"

FILENAME="rosa-linux.tar.gz"
TGZ_PATH="linux-amd64/rosa"
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="rosa-macosx.tar.gz"
  TGZ_PATH="darwin-amd64/rosa"  
fi

URL="https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/${FILENAME}"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${TGZ_PATH}"

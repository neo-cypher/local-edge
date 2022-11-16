#!/bin/bash
set -ue
set -o pipefail

CurrentFolder="notset"
Location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd  )"
echo "This script is running from: ${Location}."

traperr() {
	echo "ERROR: ${BASH_SOURCE[1]} near line ${BASH_LINENO[0]}."
}
trap traperr err

function buildWeb() {
    local filePath="$1"
    local fullPath="${Location}/${filePath}"

    echo "changing directory to ${fullPath}"
    cd "${fullPath}"
    echo "Building Web UI"
    npm install --prefer-offline --no-audit --loglevel error
    npm run build
    echo "Web UI Build Completed"
}

if [[ -d "${Location}/tardigrade-satellite-theme" ]]; then
    cp -r ${Location}/tardigrade-satellite-theme/us-central-1/ ${Location}/storj/web/satellite/
fi

echo "Building satellite web ui"
buildWeb "storj/web/satellite/"

echo "Building storagenode web ui"
buildWeb "storj/web/storagenode/"

echo "Building multinode storagenode dashboard"
buildWeb "storj/web/multinode"

echo "Building WASM"
# Generate WASM
cd "${Location}/storj/satellite/console/wasm/"
GOOS=js GOARCH=wasm go build -o access.wasm storj.io/storj/satellite/console/wasm
cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" .
echo "wasm built"
cd "${Location}"

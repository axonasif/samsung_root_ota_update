#!/usr/bin/env bash

set -eu
CONTAINER_NAME=samloader
WORK_DIR=/work
DOWNLOAD_DIR=download && mkdir -p "${DOWNLOAD_DIR}"
export CSC=${1}
export MODEL="${2}"
export IMEI=${3}
shift;shift;shift

if command -v gp 1>/dev/null; then
    export SCM_TOKEN="$(gp credential-helper get <<<host=github.com | sed -n 's/^password=//p')"
fi

docker build --build-arg WORK_DIR=${WORK_DIR} -t ${CONTAINER_NAME} .
exec docker run -e CSC -e MODEL -e IMEI -e SCM_TOKEN --net=host -v .:${WORK_DIR} -it ${CONTAINER_NAME} "$@"
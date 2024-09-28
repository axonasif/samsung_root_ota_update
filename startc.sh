#!/usr/bin/env bash

set -eu
CONTAINER_NAME=samloader
WORK_DIR=/work
export CSC=${1}
export MODEL="${2}"
export IMEI=${3}
docker build --build-arg WORK_DIR=${WORK_DIR} -t ${CONTAINER_NAME} .
exec docker run -e CSC -e MODEL -e IMEI --net=host -v .:${WORK_DIR} -it ${CONTAINER_NAME}
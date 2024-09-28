FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -yq --no-install-recommends python3 python3.12-venv git

ARG PENV_PATH=/penv
ARG BASHRC_PATH=/root/.bashrc
SHELL [ "/bin/bash", "-c" ]
RUN cd /root; python3 -m venv ${PENV_PATH} \
    && echo "source ${PENV_PATH}/bin/activate" >> ${BASHRC_PATH} \
    && bash -ic 'pip3 install git+https://github.com/ananjaser1211/samloader.git'

RUN <<EOR

cat >> ${BASHRC_PATH} <<'SCRIPT'

function up() {
    samloader -m SM-S928B -r EVR -i $IMEI checkupdate "$@"
}
function down() {
    local DL_DIR=download
    (
        mkdir -p $DL_DIR
        cd $DL_DIR
        samloader -m $MODEL -r $CSC -i $IMEI download -O . -D
    )
}
SCRIPT

EOR

ARG WORK_DIR=/work
WORKDIR ${WORK_DIR}
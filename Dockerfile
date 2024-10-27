FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -yq --no-install-recommends python3 python3.12-venv git wget p7zip

RUN mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt update \
	&& apt install gh -yq

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
    local latest_fw="$(up)"
    local vh_file="$PWD/.version_history"
    (
        mkdir -p -m 0777 $DL_DIR
        cd $DL_DIR
        samloader -m $MODEL -r $CSC -i $IMEI download -O . -D
        if ! grep -wq "${latest_fw}" "${vh_file}" 2>/dev/null && test "$(gh api user --jq '.login')" == axonasif; then
            zip_name=(*.zip)
            7z a -v2000m -mx0 ${zip_name}.7z ${zip_name}
            gh release create "${latest_fw}" --generate-notes *.7z.*
            printf '%s == %s\n' "$(up)" "$(date)" >> "${vh_file}"
            rm *.7z.*
        fi
    )
}

if test -n "${SCM_TOKEN:-}"; then
    echo "$SCM_TOKEN" | gh auth login --with-token
fi

SCRIPT

EOR

ARG WORK_DIR=/work
RUN git config --global --add safe.directory ${WORK_DIR}
WORKDIR ${WORK_DIR}
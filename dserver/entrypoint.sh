#!/bin/bash
set -e
#
DOCKER_HOST_GID="$(stat -c %g /var/run/docker.sock)"
DOCKER_CONTAINER_GID="$(awk -F':' '/docker/ {print $3}' < /etc/group)"
if [[ "${DOCKER_HOST_GID}" != "${DOCKER_CONTAINER_GID}" ]]; then
    sudo sed --in-place --expression='s/'"${DOCKER_CONTAINER_GID}"'/'"${DOCKER_HOST_GID}"'/' /etc/group
fi
if [[ ! -d "${HOME}"/.git ]]; then
    cd "${HOME}"
    git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp > /dev/null 2>&1
    mv tmp/.git .
    rm -rf tmp/ .profile
    git reset --hard  > /dev/null 2>&1
    git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git > /dev/null 2>&1
fi
#
sudo bash -c '/usr/sbin/sshd -De'

#!/bin/bash
set -e
#
DOCKER_HOST_GID="$(stat -c %g /var/run/docker.sock)"
DOCKER_CONTAINER_GID="$(awk -F':' '/docker/ {print $3}' < /etc/group)"
if [[ "${DOCKER_HOST_GID}" != "${DOCKER_CONTAINER_GID}" ]]; then
    sudo sed -ie 's/'"${DOCKER_CONTAINER_GID}"'/'"${DOCKER_HOST_GID}"'/' /etc/group 2>/dev/null
fi
if [[ ! -d /home/"${user}"/.git ]]; then
    cd /home/"${user}"
    git clone -q --recursive https://github.com/forwardcomputers/dfiles.git tmp
    mv tmp/.git .
    rm -rf tmp/ .profile
    git reset -q --hard
    git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git
    chown -R "${uid}":"${gid}" /home/"${user}"
fi
#
setpriv --reuid="${uid}" --regid="${gid}" --clear-groups \
  /opt/code-server/code-server \
    --auth none \
    --cert /opt/filer/os/acme/webcode.home.mustakim.com/webcode.home.mustakim.com.cer \
    --cert-key /opt/filer/os/acme/webcode.home.mustakim.com/webcode.home.mustakim.com.key \
    --disable-ssh \
    --disable-telemetry \
    --disable-updates \
    --extensions-dir /home/duser/.code-server/extensions/ \
    --extra-builtin-extensions-dir /opt/code-extensions/ \
    --host 0.0.0.0 \
    --port 8080 \
    --user-data-dir /home/duser/.code-server/data \
    /home/duser &
#
bash -c '/usr/sbin/sshd -De'

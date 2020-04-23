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
whoami
id
# sudo setpriv --reuid 1001 --regid 1001 --init-groups --caps=-all \
#sudo runuser -u ali \
/opt/code-server/code-server \
  --auth none \
  --cert /opt/filer/os/acme/webcode.home.mustakim.com/webcode.home.mustakim.com.cer \
  --cert-key /opt/filer/os/acme/webcode.home.mustakim.com/webcode.home.mustakim.com.key \
  --disable-telemetry \
  --disable-updates \
  --extensions-dir /home/ali/.code-server/extensions/ \
  --extra-builtin-extensions-dir /opt/code-extensions/ \
  --host 0.0.0.0 \
  --port 8080 \
  --user-data-dir /home/ali/.code-server/data \
  /home/ali &
sudo bash -c '/usr/sbin/sshd -De'

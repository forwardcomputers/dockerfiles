#
#APPNEW curl -sL "https://pypi.org/pypi/ansible/json" | jq -r '.info.version'
#
FROM python:3
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
# Install apps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y install \
    vim \
    python3-winrm \
    sshpass \
&&  pip3 install ansible ansible-lint yamllint jmespath \
&&  pip3 install -r https://raw.githubusercontent.com/linode/ansible_linode/main/requirements.txt \
#
&&  echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc \
&&  if [ ! -d /root/.ssh ]; then mkdir /root/.ssh; chmod 700 /root/.ssh; fi\
&&  echo "StrictHostKeyChecking no\nServerAliveInterval 300\nServerAliveCountMax 3\nIdentityFile /opt/filer/os/alim.pem\nUserKnownHostsFile /dev/null" > /root/.ssh/config\
#
# Clean-up
&&  rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/*.log
#

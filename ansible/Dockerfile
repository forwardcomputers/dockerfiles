#
#APPNEW curl -sL "https://pypi.org/pypi/ansible/json" | jq -r '.info.version'
#
FROM python:3
#
# Install apps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y install \
    vim \
    python3-winrm \
    sshpass \
&&  pip3 install ansible \
#
&&  echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc \
&&  if [ ! -d /root/.ssh ]; then mkdir /root/.ssh; chmod 700 /root/.ssh; fi\
&&  echo "StrictHostKeyChecking no\nServerAliveInterval 300\nServerAliveCountMax 3\nIdentityFile /opt/filer/os/alim.pem" > /root/.ssh/config\
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
ENTRYPOINT \
    if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then \
        set -- ansible "$@" \
    fi \
    exec "$@"
#
CMD [ "ansible" ]

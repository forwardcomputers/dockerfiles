#
#APPNEW curl -sL "https://pypi.org/pypi/ansible/json" | jq -r '.info.version'
#
FROM python:3-slim
#
# Install apps
RUN echo "America/Toronto" > /etc/timezone && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \ 
    pip3 install ansible proxmoxer requests && \
#
# Configuration
    echo $'America/Toronto' > /etc/timezone && \
    if [ ! -d /root/.ssh ]; then mkdir /root/.ssh; chmod 700 /root/.ssh; fi && \
    echo $'StrictHostKeyChecking no\nServerAliveInterval 300\nServerAliveCountMax 3\nIdentityFile /opt/filer/os/alim.pem' > /root/.ssh/config && \
#
# Clean-up
    rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/*.log
#


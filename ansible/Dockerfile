#
#APPNEW curl -sL "https://pypi.org/pypi/ansible/json" | jq -r '.info.version'
#
FROM python:3
#
# Install apps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \ 
    pip3 install ansible proxmoxer requests && \
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


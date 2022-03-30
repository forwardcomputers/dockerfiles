#
#APPNEW curl -sL "https://pypi.org/pypi/ansible/json" | jq -r '.info.version'
#
FROM python:3
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
# ENV DEBIAN_FRONTEND noninteractive
RUN set -e && \
#
# Install apps
  pip3 install ansible proxmoxer expect
#  pip3 install ansible proxmoxer expect && \
#
# Clean-up
#
#  rm --recursive --force \
#    /usr/share/doc/* \
#    /usr/share/man/* \
#    /var/lib/apt/lists/* \
#    /var/log/apt \
#    /var/log/*.log
#


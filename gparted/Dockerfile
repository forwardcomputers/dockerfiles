#
#APPNEW apt
#DESKTOP_NAME gparted
#DESKTOP_COMMENT Create, reorganize, and delete partitions
#DESKTOP_CATEGORIES GNOME;System;Filesystem;
#DESKTOP_MIMETYPES 
#DESKTOP_LOGO https://github.com/GNOME/gparted/raw/master/data/icons/hicolor_apps_48x48_gparted.png
#
FROM ubuntu:devel
ARG REPO
ARG VERSION
ARG TEXT
#
LABEL maintainer="Ali Mustakim <alim@forwardcomputers.com>" \
      org.label-schema.name="${REPO}" \
      org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${REPO}" \
      BuildDate="${TEXT}"
#
RUN set -e \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    dosfstools \
    gparted \
    udev \
#
# Clean-up
#
&&  rm --recursive --force \
    /usr/share/doc/* \
    /usr/share/man/* \
    /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb \
    /var/cache/apt/*.bin \
    /var/cache/debconf/*.old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/info/* \
    /var/log/apt \
    /var/log/*.log
#
ENTRYPOINT [ "gparted" ]

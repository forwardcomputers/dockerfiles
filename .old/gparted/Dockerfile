#
#APPNEW apt
#DESKTOP_NAME GParted
#DESKTOP_COMMENT Create, reorganize, and delete partitions
#DESKTOP_CATEGORIES GNOME;System;Filesystem;
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://github.com/GNOME/gparted/raw/main/data/icons/hicolor_apps_scalable_gparted.svg
#DOCKER_OPT + --user root --workdir /root --privileged
#
FROM ubuntu:rolling
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
RUN set -e \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    dosfstools \
    gparted \
    at-spi2-core \
    dbus-x11 \
    dmsetup \
    dosfstools \
    gpart \
    jfsutils \
    kpartx \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    mtools \
    netsurf-common \
    ntfs-3g \
    reiserfsprogs \
    reiser4progs \
    systemd \
    udev \
    udftools \
    xfsprogs \
    yelp \
#    dmraid \
#
# Add mimetypes
#
&&  printf '%s\n' \
    "[MIME Cache]" \
    "text/html=netsurf-gtk.desktop;" \
    "text/xml=netsurf-gtk.desktop;" \
    "x-scheme-handler/http=netsurf-gtk.desktop;" \
    "x-scheme-handler/https=netsurf-gtk.desktop;" > /usr/share/applications/mimeinfo.cache \
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


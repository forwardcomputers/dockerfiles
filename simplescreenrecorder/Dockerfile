#
#APPNEW apt
#DESKTOP_NAME SimpleScreenRecorder
#DESKTOP_COMMENT A feature-rich screen recorder that supports X11 and OpenGL
#DESKTOP_CATEGORIES AudioVideo;Video;Recorder;Qt;
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://github.com/MaartenBaert/ssr/raw/master/data/icons/scalable/simplescreenrecorder.svg
#DOCKER_OPT + --ipc=host
#
FROM ubuntu:rolling
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
    libpulse0 \
    simplescreenrecorder \
    dbus-x11 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    netsurf \
    xdg-utils \
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
    /var/log/*.log \
#
ENTRYPOINT [ "simplescreenrecorder" ]

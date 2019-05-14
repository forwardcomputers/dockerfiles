#
#APPNEW apt
#DESKTOP_NAME Pitivi
#DESKTOP_COMMENT Create and edit your own movies
#DESKTOP_CATEGORIES GNOME;GTK;AudioVideo;Video;AudioVideoEditing;
#DESKTOP_MIMETYPE text/x-xges;text/x-xptv;
#DESKTOP_LOGO https://gitlab.gnome.org/GNOME/pitivi/raw/master/data/pixmaps/pitivi.png
##DOCKER_OPT + --security-opt apparmor=unconfined
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
RUN set -e \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    libpulse0 \
    pitivi \
    dbus-x11 \
    frei0r-plugins \
    gir1.2-notify \
    gir1.2-gsound \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    netsurf \
    yaru-theme-icon \
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
ENTRYPOINT [ "pitivi" ]

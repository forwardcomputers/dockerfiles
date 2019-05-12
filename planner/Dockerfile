#
#APPNEW apt
#DESKTOP_NAME Planner
#DESKTOP_COMMENT Project Management
#DESKTOP_CATEGORIES GNOME;GTK;Office;ProjectManagement;
#DESKTOP_MIMETYPE application/x-planner;
#DESKTOP_LOGO https://github.com/GNOME/planner/raw/master/data/images/gnome-planner.svg
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
    planner \
    dbus-x11 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    planner-doc \
    netsurf \
    yelp \
#
# Add mimetypes
#
&&  printf '%s\n' \
    "[MIME Cache]" \
    "x-scheme-handler/ghelp=yelp.desktop;" \
    "x-scheme-handler/help=yelp.desktop;" \
    "x-scheme-handler/info=yelp.desktop;" \
    "x-scheme-handler/man=yelp.desktop;" \
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
ENTRYPOINT [ "planner" ]

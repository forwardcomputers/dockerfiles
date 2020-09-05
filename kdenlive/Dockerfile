#
#APPNEW curl --location --silent --url https://kdenlive.org/en/download/ | perl -nle 'print $1 if />PPA (\K[^<]+)/'
#DESKTOP_NAME Kdenlive
#DESKTOP_COMMENT Nonlinear video editor by KDE
#DESKTOP_CATEGORIES Qt;KDE;AudioVideo;AudioVideoEditing;
#DESKTOP_MIMETYPE application/x-kdenlive;
#DESKTOP_LOGO https://invent.kde.org/multimedia/kdenlive/-/raw/master/data/icons/256-apps-kdenlive.png
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
# Update repo and install dependencies
#
RUN set -e \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    software-properties-common \
&&  add-apt-repository ppa:kdenlive/kdenlive-stable \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    libpulse0 \
    netsurf \
    xdg-utils \
    \
    kdenlive \
    dbus-x11 \
    dvdauthor \
    dvgrab \
    frei0r-plugins \
    genisoimage \
    libgl1-mesa-dri \
    oxygen-icon-theme \
    recordmydesktop \
    swh-plugins \
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
&&  rm -rf \
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
ENTRYPOINT [ "kdenlive" ]

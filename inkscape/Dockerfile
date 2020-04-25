#
#aPPNEW curl --location --silent --url https://inkscape.org | perl -nle 'print $1 if /Current stable version: (\K[^<]+)/'
#APPNEW apt
#DESKTOP_NAME Inkscape
#DESKTOP_COMMENT Create and edit Scalable Vector Graphics images
#DESKTOP_CATEGORIES Graphics;VectorGraphics;GTK;
#DESKTOP_MIMETYPE image/svg+xml;image/svg+xml-compressed;application/vnd.corel-draw;application/pdf;application/postscript;image/x-eps;application/illustrator;image/cgm;image/x-wmf;application/x-xccx;application/x-xcgm;application/x-xcdt;application/x-xsk1;application/x-xcmx;image/x-xcdr;application/visio;application/x-visio;application/vnd.visio;application/visio.drawing;application/vsd;application/x-vsd;image/x-vsd;
#DESKTOP_LOGO https://gitlab.com/inkscape/inkscape/raw/master/share/branding/inkscape.svg
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
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    libpulse0 \
    inkscape \
    inkscape-tutorials \
    aspell \
    dbus-x11 \
    fig2dev \
    imagemagick \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libimage-magick-perl \
    libwmf-bin \
    netsurf \
    python3-lxml \
    python3-numpy \
    python3-scour \
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
ENTRYPOINT [ "inkscape" ]

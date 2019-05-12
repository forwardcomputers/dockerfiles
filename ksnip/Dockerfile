#
#APPNEW curl --location --header "${GH_AUTH_HEADER}" --header "${GH_API_HEADER}" --silent --url https://api.github.com/repos/DamirPorobic/ksnip/releases/latest | jq -r '.tag_name | split("v")[1]'
#DESKTOP_NAME ksnip
#DESKTOP_COMMENT Cross-platform screenshot tool that provides many annotation features for your screenshots.
#DESKTOP_CATEGORIES Utility;
#DESKTOP_MIMETYPE
#DESKTOP_LOGO https://github.com/DamirPorobic/ksnip/raw/master/desktop/ksnip.svg
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
    dbus-x11 \
    ca-certificates \
    curl \
    hicolor-icon-theme \
    jq \
    libqt5core5a \
    libqt5dbus5 \
    libqt5gui5 \
    libqt5network5 \
    libqt5printsupport5 \
    libqt5svg5 \
    libqt5widgets5 \
    libqt5x11extras5 \
    libqt5xml5 \
    qt5-gtk-platformtheme \
    netsurf \
    yelp \
    xdg-utils \
#
# Install application
#
&&  curl --location --output ./ksnip.deb --silent --url https://github.com/DamirPorobic/ksnip/releases/download/v"${APPNEW}"/ksnip-"${APPNEW}".deb \
&&  dpkg --install ./ksnip.deb \
&&  apt-get -qq install --fix-broken --no-install-recommends --yes \
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
    ./ksnip.deb \
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
ENTRYPOINT [ "ksnip" ]

#
#APPNEW curl --location --silent --url https://www.torproject.org/download | perl -nle 'print $1 if /linux64-(\K[^_]+)/' | head -1
#DESKTOP_NAME TorBrowser
#DESKTOP_COMMENT Tor Browser is +1 for privacy and -1 for mass surveillance
#DESKTOP_CATEGORIES Network;WebBrowser;Security;
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://gitweb.torproject.org/torbrowser.git/plain/build-scripts/branding/default256.png
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
    bzip2 \
    ca-certificates \
    curl \
    libavcodec-extra \
    libasound2 \
    libpulse0 \
    xz-utils \
    adwaita-icon-theme-full \
    libatk1.0-0 \
    libc6 \
    libcairo-gobject2 \
    libcairo2 \
    libdbus-1-3 \
    libdbus-glib-1-2 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstartup-notification0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb-shm0 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrender1 \
    libxt6 \
    lsb-release \
    xul-ext-ubufox \
    libcanberra0 \
    libdbusmenu-glib4 \
    libdbusmenu-gtk3-4 \
    fonts-lyx \
#
# Install application
#
&&  appver=$( curl --location --silent --url https://www.torproject.org/projects/torbrowser.html.en | \
    awk -F'/' '/linux64/ { print $4; exit }' ) \
&&  curl --location --silent --url \
    https://www.torproject.org/dist/torbrowser/"${appver}"/tor-browser-linux64-"${appver}"_en-US.tar.xz | \
    tar --extract --xz --directory /opt \
&&  chown --recursive "${uid}:${gid}" /opt/tor-browser_en-US \
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
ENTRYPOINT [ "/opt/tor-browser_en-US/Browser/start-tor-browser" ]

#
#APPNEW curl --location --silent --url http://www.mozilla.org | perl -nle 'print $1 if /data-esr-versions="(\K[^"]+)/'
#DESKTOP_NAME FirefoxESR
#DESKTOP_COMMENT Browse the World Wide Web
#DESKTOP_CATEGORIES GNOME;GTK;Network;WebBrowser;
#DESKTOP_MIMETYPE text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
#DESKTOP_LOGO https://dxr.mozilla.org/mozilla-release/raw/browser/branding/official/default256.png
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
    bzip2 \
    ca-certificates \
    curl \
    libavcodec-extra \
    libasound2 \
    libpulse0 \
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
    > /dev/null \
#
# Install application
#
&&  curl --location --silent --url \
    'https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=linux64&lang=en-US' | \
    tar --extract --bzip2 --directory /opt \
&&  ln --symbolic /opt/firefox/firefox /opt/firefox/firefox-esr \
&&  chown --recursive "${uid}:${gid}" /opt/firefox \
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
ENTRYPOINT [ "/opt/firefox/firefox-esr" ]

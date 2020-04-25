#
#APPNEW curl --location --silent --url https://code.visualstudio.com/updates | grep -o -P '(?<=Linux: <a href="https://update.code.visualstudio.com/).*?(?=/linux)'
#DESKTOP_NAME VSCode
#DESKTOP_COMMENT Code Editing. Redefined.
#DESKTOP_CATEGORIES Utility;TextEditor;Development;IDE;
#DESKTOP_MIMETYPE text/plain;inode/directory;
#DESKTOP_LOGO https://github.com/forwardcomputers/dockerfiles/raw/master/code/code.png
#dDESKTOP_LOGO https://github.com/flathub/com.visualstudio.code/raw/master/icons/vscode_256.png
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
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    libpulse0 \
    software-properties-common \
&&  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg \
&&  install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/ \
&&  echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    code \
    git \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libcups2 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgtk2.0-0 \
    libpango-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    netsurf \
    openssh-client \
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
    /var/log/*.log
#
ENTRYPOINT [ "/usr/share/code/code" ]

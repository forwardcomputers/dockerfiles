#
#aPPNEW curl --location --header '"${GH_AUTH_HEADER}"' --header '"${GH_API_HEADER}"' --silent --url https://api.github.com/repos/audacity/audacity/releases/latest | jq -r '.tag_name | split("-")[1]'
#APPNEW apt
#DESKTOP_NAME Audacity
#DESKTOP_COMMENT Record and edit audio files
#DESKTOP_CATEGORIES AudioVideo;Audio;AudioVideoEditing;
#DESKTOP_MIMETYPE application/x-audacity-project;
#DESKTOP_LOGO https://github.com/audacity/audacity/raw/master/images/audacity.svg
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
    audacity \
    ca-certificates \
    dbus-x11 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    multimedia-audio-plugins \
    netsurf \
    yaru-theme-gtk \
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
ENTRYPOINT [ "audacity" ]


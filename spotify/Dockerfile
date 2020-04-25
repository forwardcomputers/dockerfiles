#
#APPNEW curl -s http://repository.spotify.com/dists/stable/non-free/binary-amd64/Packages | awk '/^Package: spotify-client/{found++} /^Version: / {sub(/.*:/,""); print $1; exit}'
#DESKTOP_NAME Spotify
#DESKTOP_COMMENT Music Player
#DESKTOP_CATEGORIES Audio;Music;Player;AudioVideo;
#DESKTOP_MIMETYPE x-scheme-handler/spotify;
#DESKTOP_LOGO https://github.com/forwardcomputers/dockerfiles/raw/master/spotify/spotify-linux-256.png
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
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
&&  curl -s https://download.spotify.com/debian/pubkey.gpg | apt-key add - > /dev/null \
&&  echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list \
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    spotify-client \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpulse0 \
    > /dev/null \
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
ENTRYPOINT [ "/usr/bin/spotify" ]

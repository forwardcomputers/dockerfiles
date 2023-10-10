#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
#
FROM forwardcomputers/base_alpine
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
# Update repos and install packages
#
&&  apk add --no-cache \
    libmediainfo \
    mono \
    sqlite-libs \
    tinyxml2 \
#
&&  curl -sL "https://services.sonarr.tv/v1/download/develop/latest?version=4&os=linux-musl&arch=arm64" | tar xzf - -C "/opt" --exclude "Sonarr.Update" \
&&  chown -R 1001:1001 /opt/* \
&&  /usr/bin/cert-sync /etc/ssl/certs/ca-certificates.crt \
#
&&  rm -rf \
    /var/cache/apk \
    /var/lib/apk
#


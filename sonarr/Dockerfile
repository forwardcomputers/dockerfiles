#
#APPNEW curl -sL "https://services.sonarr.tv/v1/download/main" | jq -r '.version'
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
    icu-libs \
    libintl \
#
&&  curl -sL "https://services.sonarr.tv/v1/download/develop/latest?version=4&os=linuxmusl" | tar xzf - -C "/opt" --exclude "Sonarr.Update" \
&&  rm -rf /opt/Sonarr/Sonarr.Update \
&&  chown -R 1001:1001 /opt/* \
#
&&  rm -rf \
    /var/cache/apk \
    /var/lib/apk
#

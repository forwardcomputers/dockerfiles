#
#APPNEW curl -sL https://git.alpinelinux.org/aports/plain/community/telegram-desktop/APKBUILD | awk -F= '/pkgver=/ {print $2}'
#
# Alpine image
FROM alpine:edge
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
# Install application
#
RUN apk add --no-cache --update \
    dnsmasq \
#
# Clean-up
#
&& rm -rf \
   /etc/apk \
   /lib/apk \
   /sbin/apk \
   /usr/share/apk \
   /var/lib/apk
#
ENTRYPOINT "sh"

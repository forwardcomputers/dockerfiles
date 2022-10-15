#
#APPNEW curl -sl https://www.speedtest.net/apps/cli | awk -F '>i386<|>x86_64<' '{sub(/.*ookla-speedtest-/,"",$2); sub(/-linux-x86_64.*$/,"",$2); print $2}' | grep .  
#
# Alpine image
FROM alpine:latest
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
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
RUN apk add --no-cache --update bash net-snmp-tools openssh-client \
&&  wget -qO - https://install.speedtest.net/app/cli/ookla-speedtest-${APPNEW}-linux-x86_64.tgz | tar -xzf - -C /usr/local/bin speedtest \
#
# Clean-up
#
&&  rm -rf \
    /etc/apk \
    /lib/apk \
    /usr/share/apk \
    /var/lib/apk
#
ENTRYPOINT [ "crond", "-f" ]

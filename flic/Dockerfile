#
#APPNEW curl -sL "https://api.github.com/repos/50ButtonsEach/fliclib-linux-hci/releases/latest" | jq -r '.tag_name'  
#
FROM debian:testing
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
ARG DEBIAN_FRONTEND=noninteractive
ARG FLICD_PORT_DEFAULT=5551
ARG FLICD_DEVICE_DEFAULT=hci0
ENV FLICD_PORT=$FLICD_PORT_DEFAULT
ENV FLICD_DEVICE=$FLICD_DEVICE_DEFAULT
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
RUN apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    bluez \
    ca-certificates \
    dbus \
    git \
#
# Install application
#
&&  git clone --depth 1 -b "${APPNEW}" https://github.com/50ButtonsEach/fliclib-linux-hci /tmp/src \
&&  cp /tmp/src/bin/x86_64/flicd /usr/local/bin/flicd \
&&  chmod +x /usr/local/bin/flicd \
#
# Clean-up
#
&&  rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /var/lib/apt \
    /var/lib/dpkg/info \
    /var/log/apt \
    /var/log/journal \
    /var/log/xrdp* \
    /var/log/*.log \
    /tmp/*
#
WORKDIR /data
EXPOSE 5551
ENTRYPOINT [ "/bin/bash", "-c", "service dbus restart && service bluetooth start && flicd -f /data/flic.db -s 0.0.0.0 -p $FLICD_PORT -h $FLICD_DEVICE" ]

#
#APPNEW curl -sL "https://api.github.com/repos/duplicati/duplicati/releases" | jq -r 'first ( .[] | select( .tag_name | contains( "stable" ) ).tag_name )[1:]'
#
FROM debian:latest
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
RUN apt update && apt install tini
ENTRYPOINT [ "/usr/bin/tini", "--" ]

RUN apt update -y && apt install -y libssl3 ca-certificates gnupg libicu72 rclone

ENV XDG_CONFIG_HOME=/data
VOLUME /data

ARG CHANNEL=
ARG VERSION=
ENV DUPLICATI_CHANNEL=${CHANNEL}
ENV DUPLICATI_VERSION=${VERSION}

ENV DUPLICATI__WEBSERVICE_PORT=8200
ENV DUPLICATI__WEBSERVICE_INTERFACE=any

ARG TARGETARCH
COPY ./${TARGETARCH} /opt/duplicati

EXPOSE 8200
CMD ["/opt/duplicati/duplicati-server"]


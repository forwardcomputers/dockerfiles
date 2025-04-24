#
#APPNEW curl -sL "https://api.github.com/repos/AmanoTeam/Kad/releases/latest" | jq -r '.tag_name[1:]'
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
ENV user="ali" \
    uid="1001" \
    gid="1001"
#
# Install application
#
RUN set -e \
&&  apk --update --no-cache add \
    ca-certificates \
    curl \
&&  mkdir -p /opt/kad \
&&  curl -sL https://github.com/AmanoTeam/Kad/releases/download/v"${APPNEW}"/x86_64-unknown-linux-musl.tar.xz | tar -x --xz --strip-components=1 -C /opt/kad \
&&  chown -R "${uid}:${gid}" /opt/kad
#
EXPOSE 4000
#
ENTRYPOINT [ "/opt/kad/bin/kad", "--host=0.0.0.0" ]


#
#APPNEW curl -sL "https://api.github.com/repos/nicolargo/glances/releases/latest" | jq -r '.tag_name[1:]'
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
#RUN apk add --no-cache inkscape dbus-x11 midori
RUN apk add --no-cache \
    git \
    lm-sensors \
    py3-bottle \
    py3-psutil \
    wireless-tools \
#
# Install application
#
&&  git clone https://github.com/nicolargo/glances.git
#
# Clean-up
#
#&& rm -rf \
#   /etc/apk \
#   /lib/apk \
#   /sbin/apk \
#   /usr/share/apk \
#   /var/lib/apk
#
EXPOSE 61208/tcp 61209/tcp
WORKDIR /glances
ENTRYPOINT /usr/bin/python3 -m glances -C /glances/conf/glances.conf $GLANCES_OPT

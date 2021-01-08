#
#aPPNEW curl --location --header '"${GH_AUTH_HEADER}"' --header '"${GH_API_HEADER}"' --silent --url https://api.github.com/repos/audacity/audacity/releases/latest | jq -r '.tag_name | split("-")[1]'
#APPNEW apk
#DESKTOP_NAME Audacity
#DESKTOP_COMMENT Record and edit audio files
#DESKTOP_CATEGORIES AudioVideo;Audio;AudioVideoEditing;
#DESKTOP_MIMETYPE application/x-audacity-project;
#DESKTOP_LOGO https://github.com/audacity/audacity/raw/master/images/audacity.svg
#
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
RUN set -e \
#
# Update Ubuntu repos and install dependencies
#
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories \
&&  apk add --no-cache --update \
    audacity \
    multimedia-audio-plugins \
#
    dbus-x11 \
    libcanberra-gtk2 \
    libcanberra-gtk3 \
    libpulse0
#
ENTRYPOINT [ "audacity" ]


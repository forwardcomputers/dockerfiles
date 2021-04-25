#
#APPNEW apk
#DESKTOP_NAME Blender
#DESKTOP_COMMENT 3D modeling, animation, rendering and post-production
#DESKTOP_CATEGORIES Graphics;3DGraphics;
#DESKTOP_MIMETYPE application/x-blender;
#DESKTOP_LOGO https://github.com/sobotka/blender/raw/master/release/freedesktop/icons/scalable/apps/blender.svg
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
# Install application & dependencies
#
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories \
&&  apk add --no-cache --update \
    blender \
#
    adwaita-icon-theme \
    dbus-x11 \
    libcanberra-gtk2 \
    libcanberra-gtk3 \
    libpulse \
    mesa-dri-gallium \
    ttf-freefont \
#
&&  adduser -D -H -u 1001 duser 1001 \
&&  addgroup duser audio
#
ENTRYPOINT [ "blender" ]

#
#APPNEW apk
#DESKTOP_NAME Flameshot
#DESKTOP_COMMENT Powerful yet simple to use screenshot software
#DESKTOP_CATEGORIES Graphics;
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://github.com/lupoDharkael/flameshot/raw/master/img/app/flameshot.svg
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
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories \
&&  apk add --no-cache --update \
    flameshot \
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
ENTRYPOINT [ "/usr/bin/flameshot" ]

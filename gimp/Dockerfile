#
#APPNEW apk
#DESKTOP_NAME GIMP
#DESKTOP_COMMENT Create images and edit photographs
#DESKTOP_CATEGORIES Graphics;2DGraphics;RasterGraphics;GTK;
#DESKTOP_MIMETYPE image/bmp;image/g3fax;image/gif;image/x-fits;image/x-pcx;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-psd;image/x-sgi;image/x-tga;image/x-xbitmap;image/x-xwindowdump;image/x-xcf;image/x-compressed-xcf;image/x-gimp-gbr;image/x-gimp-pat;image/x-gimp-gih;image/tiff;
#DESKTOP_LOGO https://gitlab.gnome.org/GNOME/gimp/raw/master/desktop/256x256/gimp.png
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
RUN set -e \
#
# Install application
#
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories \
&&  apk add --no-cache --update \
    gimp \
    gvfs \
    iso-codes \
    ttf-freefont \
    yelp \
#
    adwaita-icon-theme \
    dbus-x11 \
    libcanberra-gtk2 \
    libcanberra-gtk3 \
    mesa-dri-gallium \
    midori \
    xdg-utils \
#
# Add mimetypes
#
&&  printf '%s\n' \
    "[MIME Cache]" \
    "x-scheme-handler/ghelp=yelp.desktop;" \
    "x-scheme-handler/help=yelp.desktop;" \
    "x-scheme-handler/info=yelp.desktop;" \
    "x-scheme-handler/man=yelp.desktop;" \
    "application/x-extention-htm=org.midori_browser.Midori.desktop;" \
    "application/x-extention-html=org.midori_browser.Midori.desktop;" \
    "application/x-extention-shtml=org.midori_browser.Midori.desktop;" \
    "application/x-extention-xht=org.midori_browser.Midori.desktop;" \
    "application/xhtml+xml=org.midori_browser.Midori.desktop;" \
    "application/xml=org.midori_browser.Midori.desktop;" \
    "image/svg+xml=org.midori_browser.Midori.desktop;" \
    "text/html=org.midori_browser.Midori.desktop;" \
    "text/xml=org.midori_browser.Midori.desktop;" \
    "x-scheme-handler/http=org.midori_browser.Midori.desktop;" \
    "x-scheme-handler/https=org.midori_browser.Midori.desktop;" \
    "x-scheme-handler/geo=org.midori_browser.Midori.desktop;" > /usr/share/applications/mimeinfo.cache
#
ENTRYPOINT [ "gimp" ]


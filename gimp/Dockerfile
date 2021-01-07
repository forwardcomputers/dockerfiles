#
#APPNEW apk
#DESKTOP_NAME GIMP
#DESKTOP_COMMENT Create images and edit photographs
#DESKTOP_CATEGORIES Graphics;2DGraphics;RasterGraphics;GTK;
#DESKTOP_MIMETYPE image/bmp;image/g3fax;image/gif;image/x-fits;image/x-pcx;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-psd;image/x-sgi;image/x-tga;image/x-xbitmap;image/x-xwindowdump;image/x-xcf;image/x-compressed-xcf;image/x-gimp-gbr;image/x-gimp-pat;image/x-gimp-gih;image/tiff;
#DESKTOP_LOGO https://gitlab.gnome.org/GNOME/gimp/raw/master/desktop/256x256/gimp.png
#
# Alpine image
FROM alpine
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
    dbus-x11 \
    ghostscript-fonts \
    gimp \
    iso-codes \
    libcanberra-gtk2 \

#
# Add mimetypes
#
# &&  printf '%s\n' \
#     "[MIME Cache]" \
#     "text/html=netsurf-gtk.desktop;" \
#     "text/xml=netsurf-gtk.desktop;" \
#     "x-scheme-handler/http=netsurf-gtk.desktop;" \
#     "x-scheme-handler/https=netsurf-gtk.desktop;" > /usr/share/applications/mimeinfo.cache \
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
ENTRYPOINT [ "gimp" ]


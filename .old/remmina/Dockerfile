#
#APPNEW curl -s https://git.alpinelinux.org/aports/plain/community/remmina/APKBUILD | awk -F= '/pkgver=/ {print $2}'
#DESKTOP_NAME Remmina
#DESKTOP_COMMENT Connect to remote desktops
#DESKTOP_CATEGORIES GTK;GNOME;X-GNOME-NetworkSettings;Network;
#DESKTOP_MIMETYPE application/x-remmina;
#DESKTOP_LOGO https://gitlab.com/Remmina/Remmina/raw/master/data/desktop/scalable/apps/org.remmina.Remmina.svg
#DOCKER_OPT + -e XDG_CONFIG_HOME=/opt/filer/os/lnx/data/remmina/config -e XDG_DATA_HOME=/opt/filer/os/lnx/data/remmina/data
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
# Install application
#
RUN apk -U --no-cache --allow-untrusted add \
    remmina \
    adwaita-icon-theme \
    libpulse \
#
# Clean-up
#
&&  rm -r -f \
    /etc/apk \
    /lib/apk \
    /sbin/apk \
    /usr/share/apk \
    /var/lib/apk
#
ENTRYPOINT [ "remmina" ]

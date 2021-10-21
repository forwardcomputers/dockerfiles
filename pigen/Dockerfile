#
#APPNEW 1.0
#
FROM i386/debian:buster
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
ENV DEBIAN_FRONTEND noninteractive
RUN set -e \
#
# Install apps
#
&&  apt-get update && apt-get install --no-install-recommends --yes \
    cron curl gawk jq msmtp \
    git vim parted \
    quilt coreutils qemu-user-static debootstrap zerofree zip dosfstools \
    libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc\
    binfmt-support ca-certificates qemu-utils kpartx \
#
# Clean-up
#
&&  rm --recursive --force \
    /var/lib/apt/lists/*
#
#ENTRYPOINT [ "bash" ]

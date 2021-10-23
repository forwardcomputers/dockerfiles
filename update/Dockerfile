#
#APPNEW 1.0
#
#FROM ubuntu:latest
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
RUN set -e \
#
# Install apps
# [Ubuntu - Debian] mkisofs - genisoimage
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    apt-transport-https \
    ca-certificates \
    coreutils \
    binutils \
    build-essential \
    cron \
    curl \
    file \
    gawk \
    gcc \
    gcc-aarch64-linux-gnu \
    gcc-arm-none-eabi \
    genisoimage \
    git \
    gpg-agent \
    grub-efi \
    open-iscsi \
    isolinux \
    jq \
    liblzma-dev \
    libxml2-utils \
    msmtp \
    p7zip-full \
    sbsigntool \
    software-properties-common \
    vim \
    git vim parted \
    quilt coreutils qemu-user-static debootstrap zerofree zip dosfstools \
    libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc\
    binfmt-support ca-certificates qemu-utils kpartx \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    imagemagick \
#
&&  add-apt-repository ppa:arx/release \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes innoextract \
#
&&  YQNEW=$(curl -sL "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r '.tag_name') \
&&  curl -L -o/usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/"${YQNEW}"/yq_linux_amd64 \
&&  chmod +x /usr/local/bin/yq \
#
# Clone repos
#
&&  git clone https://github.com/ipxe/ipxe.git /ipxe \
&&  git clone https://github.com/RPi-Distro/pi-gen.git /pi-gen \
#
# Clean-up
#
&&  rm --recursive --force \
    /usr/share/doc/* \
    /usr/share/man/* \
    /var/lib/apt/lists/* \
    /var/log/apt \
    /var/log/*.log
#
ENTRYPOINT [ "bash" ]


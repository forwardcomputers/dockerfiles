#
#APPNEW curl -sL "https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-amd64/testing/rootfs.debian_version" | cut -f1 -d\/
#PLATFORM --platform=linux/amd64,linux/arm64
#
FROM debian:testing-slim
ARG TARGETARCH
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
ARG DEBIAN_FRONTEND=noninteractive
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
# Update repos and install packages
#
&&  sed -i 's/main.*/main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources \
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    ca-certificates \
    cpio \
    g++ \
    gcc \
    git \
    gzip \
    locales \
    libncurses5-dev \
    libdevmapper-dev \
    libsystemd-dev \
    make \
    patch \
    perl \
    sed \
    unzip \
    wget \
#
# Configure
#
# create locales
&&  localedef -c -i en_US -f UTF8 -A /usr/share/locale/locale.alias en_US.UTF8 \
&&  update-locale --no-checks LANG=en_US.UTF8 \
#
# clone buildroot
&&  git clone git://git.buildroot.net/buildroot \
#
# &&  touch /buildroot/.config \
# &&  touch /buildroot/kernel.config \
#
# Clean-up
#
&&  apt autoremove --purge -y \
&&  apt clean \
&&  rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /var/lib/apt \
    /var/lib/dpkg/info \
    /var/log/apt \
    /var/log/journal \
    /var/log/*.log \
    /tmp/*
#
WORKDIR /buildroot

RUN ["/bin/bash"]
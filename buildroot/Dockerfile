#
#APPNEW curl -sL "https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-amd64/testing/rootfs.debian_version" | cut -f1 -d\/
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
    vim \
    wget \
#
# Configure
#
# create locales
&&  sed -e '/en_US.UTF-8/s/^# *//g' -i /etc/locale.gen \
&&  echo "LANG=en_US.UTF-8" > /etc/default/locale \
&&  locale-gen \
#
# clone buildroot
&&  git clone git://git.buildroot.net/buildroot \
#
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
#
RUN ["/bin/bash"]
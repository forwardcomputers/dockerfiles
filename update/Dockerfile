#
#APPNEW 2.0
#
FROM forwardcomputers/base_debian
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
&&  apt-get update && apt-get install --no-install-recommends --yes \
    aria2 \
    ca-certificates \
    cabextract \
    coreutils \
    binutils \
    build-essential \
    chntpw \
    cpio \
    cron \
    curl \
    fdisk \
    file \
    gawk \
    gcc \
    gcc-aarch64-linux-gnu \
    gcc-arm-none-eabi \
    genisoimage \
    git \
    gnupg \
    gpg-agent \
    grub-efi \
    isolinux \
    jq \
    libc6-dev-i386 \
    libgcc-s1 \
    libguestfs-tools \
    liblzma-dev \
    libxml2-utils \
    lsof \
    mkisofs \
    msmtp \
    netcat-openbsd \
    open-iscsi \
    openssh-client \
    p7zip-full \
    sbsigntool \
    software-properties-common \
    squashfs-tools \
    vim \
    wimtools \
    git vim parted \
    quilt coreutils qemu-user-static debootstrap zerofree zip dosfstools syslinux-common \
    libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc\
    binfmt-support ca-certificates qemu-utils \
    libncurses-dev nasm unzip \
&&  apt-get update && apt-get install --yes \
    imagemagick \
#
&&  . /etc/os-release \
# &&  curl -fsSL "http://download.opensuse.org/repositories/home:/dscharrer/Debian_Testing/Release.key" | gpg --dearmor -o /etc/apt/trusted.gpg.d/arx.gpg \
# &&  echo "deb [trusted=yes] http://download.opensuse.org/repositories/home:/dscharrer/Debian_Testing/ /" | tee /etc/apt/sources.list.d/arx.list > /dev/null \
# &&  apt-get update && apt-get install --no-install-recommends --yes innoextract \
#
&&  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg \
&&  echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
         bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    docker-ce-cli \
#
&&  YQNEW=$( curl -sL "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r '.tag_name' ) \
&&  curl -sLo /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQNEW}/yq_linux_amd64" \
&&  chmod +x /usr/local/bin/yq \
#
# Clone repos
#
&&  git clone https://github.com/ipxe/ipxe.git \
&&  git clone https://github.com/RPi-Distro/pi-gen.git \
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

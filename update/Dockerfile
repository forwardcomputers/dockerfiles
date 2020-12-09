#
#APPNEW 1.0
#
FROM ubuntu:rolling
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
# Install apps
#
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
    git \
    grub-efi \
    isolinux \
    jq \
    liblzma-dev \
    libxml2-utils \
    mkisofs \
    msmtp \
    p7zip-full \
    vim \
#
&&  YQNEW=$(curl -sL "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r '.tag_name') \
&&  curl -L -o/usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/"${YQNEW}"/yq_linux_amd64 \
&&  chmod +x /usr/local/bin/yq \
#
# Clean-up
#
&&  rm --recursive --force \
    /usr/share/doc/* \
    /usr/share/man/* \
    /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb \
    /var/cache/apt/*.bin \
    /var/cache/debconf/*.old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/info/* \
    /var/log/apt \
    /var/log/*.log
#
ENTRYPOINT [ "bash" ]

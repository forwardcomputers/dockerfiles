#
#APPNEW 1.0
#
FROM debian:testing-slim
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
ENV USER="ali" \
    PUID="1001" \
    PGID="1001" \
    APP_DIR="/app" \
    CONFIG_DIR="/config" \
    XDG_CONFIG_HOME="${CONFIG_DIR}/.config" \
    XDG_CACHE_HOME="${CONFIG_DIR}/.cache" \
    XDG_DATA_HOME="${CONFIG_DIR}/.local/share" \
    TZ="America/Toronto" \
    CLANG="en" \
    CNTRY="US" \
    CHAR="UTF-8" \
    LANG="{$CLANG}_{$CNTRY}.{$CHAR}" \
    LANGUAGE="{$CLANG}_{$CNTRY}:{$CLANG}" \
    LC_ALL="{$CLANG}_{$CNTRY}.{$CHAR}"
#
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
#
RUN set -e \
#
# Update repos and install packages
#
&&  sed -i 's/main.*/main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources \
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    jq \
    locales \
    p7zip-full \
    tzdata \
    unrar \
    unzip \
    xz-utils \
#
&&  S6NEW=$( curl -sL "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | jq -r '.tag_name | gsub("v";"")' ) \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-x86_64.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C / \
#
# Clean-up
#
&&  apt autoremove -y \
&&  apt clean \
&&  rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /var/lib/apt \
    /var/lib/dpkg/info \
    /var/log/apt \
    /var/log/journal \
    /var/log/xrdp* \
    /var/log/*.log \
    /tmp/* \
#
# Configure
#
# Create locales
&&  localedef -i "{$CLANG}_{$CNTRY}" -c -f "{$CHAR}" -A /usr/share/locale/locale.alias "{$CLANG}_{$CNTRY}.{$CHAR}" \
# Create timezone
&&  ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime \
&&  echo "${TZ}" > /etc/timezone \
# Create folders
&&  echo mkdir -p {"${APP_DIR}","${CONFIG_DIR}"} | bash \
# Create user
&&  useradd -U -d "${CONFIG_DIR}" -s /bin/false -u "${PUID}" "${USER}" \
&&  usermod -G users "${USER}"
#
ENTRYPOINT [ "/init" ]


#
#APPNEW curl -sL "https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-amd64/testing/rootfs.debian_version"
#PLATFORM --platform=linux/amd64,linux/arm64
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
    TZ="America/Toronto" \
    _CHAR="UTF-8" \
    _LANG="en" \
    _CNTRY="US"
ENV XDG_CONFIG_HOME=${CONFIG_DIR}/.config \
    XDG_CACHE_HOME=${CONFIG_DIR}/.cache \
    XDG_DATA_HOME=${CONFIG_DIR}/.local/share \
    LANG=${_LANG}_${_CNTRY}.${_CHAR} \
    LANGUAGE=${_LANG} \
    LC_ALL=${_LANG}_${_CNTRY}.${_CHAR}
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_VERBOSITY=1
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
    tzdata \
    xz-utils \
#
&&  S6NEW=$( curl -sL "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | jq -r '.tag_name | gsub("v";"")' ) \
&&  curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-noarch.tar.xz" | tar -Jpxf - -C / \
&&  curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-x86_64.tar.xz" | tar -Jpxf - -C / \
&&  curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-noarch.tar.xz" | tar -Jpxf - -C / \
&&  curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-arch.tar.xz" | tar -Jpxf - -C / \
#
# Configure
#
# Create locales
&&  localedef -c -i "${_LANG}_${_CNTRY}" -f "${_CHAR}" -A /usr/share/locale/locale.alias "${LANG}" \
&&  update-locale --no-checks LANG="${LANG}" \
# Create timezone
&&  cp -f "/usr/share/zoneinfo/${TZ}" /etc/localtime \
&&  echo "${TZ}" > /etc/timezone \
# Create folders
&&  echo mkdir -p {"${APP_DIR}","${CONFIG_DIR}"} | bash \
# Create user
&&  useradd -U -d "${CONFIG_DIR}" -s /bin/false -u "${PUID}" "${USER}" \
&&  usermod -G users "${USER}" \
#
# Clean-up
#
&&  apt purge -y tzdata \
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
ENTRYPOINT [ "/init" ]

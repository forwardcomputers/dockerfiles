#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
#
FROM alpine:latest AS builder

RUN apk --update --no-cache add \
    autoconf \
    automake \
    binutils \
    build-base \
    cmake \
    cppunit-dev \
    curl-dev \
    libtool \
    linux-headers \
    zlib-dev \
# Install unrar from source
&&  UNRAR_VER=$( wget -qO- https://www.rarlab.com/rar_add.htm | awk -F'"' '/unrarsrc/ {print $2}' ) \
&&  cd /tmp \
&&  wget -qO- "https://www.rarlab.com/${UNRAR_VER}" | tar -xzf - \
&&  cd unrar \
&&  make -f makefile \
&&  install -Dm 755 unrar /usr/bin/unrar

FROM alpine:latest

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
#
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
#
RUN set -e \
#
# Update repos and install packages# Update repos and install packages
#
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories \
&&  apk --update --no-cache add \
    bash \
    ca-certificates \
    coreutils \
    curl \
    findutils \
    grep \
    jq \
    p7zip \
    sed \
    tzdata \
    unzip \
#
&&  S6NEW=$( curl -sL "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | jq -r '.tag_name | gsub("v";"")' ) \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-x86_64.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / \
&&  curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6NEW}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C / \
#
# Configure
#
# Create timezone
&&  cp -f "/usr/share/zoneinfo/${TZ}" /etc/localtime \
&&  echo "${TZ}" > /etc/timezone \
# Create folders
&&  echo mkdir -p {"${APP_DIR}","${CONFIG_DIR}"} | bash \
# Create user
&&  adduser -D -h "${CONFIG_DIR}" -s /bin/false "${PUID}" "${USER}" \
&&  addgroup "${USER}" users \
#
# Clean-up
#
&&  apk del tzdata \
&&  rm -rf \
    /var/cache/apk \
    /var/lib/apk
#
COPY --from=builder /usr/bin/unrar /usr/bin/
#
ENTRYPOINT [ "/init" ]

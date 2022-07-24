#
#APPNEW 1.0
#PLATFORM --platform=linux/amd64
#
FROM debian:latest
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
    uid="1001" \
    gid="1001" 
#
RUN set -e \
&&  export USER="${USER}" uid="${uid}" gid="${gid}" \
#
# Update repos and install packages
#
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    apt-utils \
    ca-certificates \
    coreutils \
    curl \
    file \
    findutils \
    grep \
    iproute2 \
    ftp \
    gnupg \
    jq \
    less \
    openssh-client \
    gawk \
    git \
    lastpass-cli \
    locales \
    lsb-release \
    procps \
    psmisc \
    sudo \
    tmux \
    vim-tiny \
    \
    bash \
    bash-completion \
    zsh \
    zsh-common \
    \
    hsetroot \
    openbox \
    ltpanel \
    lxterminal \
    xorgxrdp \
    xrdp \
    xvfb \
    \
    # arc \
    # bzip2\
    # cabextract \
    # cpio \
    # extract \
    # gzip \
    # p7zip \
    # unace \
    # unzip \
    # xz-utils \
    # zpaq \
#
&&  apt-get -y install \
    firefox-esr \
    libpci3 \
#
&&  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg \
&&  echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
         bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
        #  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    docker-ce-cli \
    docker-compose-plugin \
#
# Install application
#
&&  TTYDNEW=$(curl -sL "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | jq -r '.tag_name') \
&&  curl -sLo /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/${TTYDNEW}/ttyd.x86_64" \
&&  chmod +x /usr/local/bin/ttyd \
#
# Clean-up
#
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
# Create unprivileged user
#
&&  sed -i '/en_US.UTF/ s/^#//;s/^ *//' /etc/locale.gen \
&&  update-locale --no-checks LANG="en_US.UTF-8" \
&&  locale-gen "en_US.UTF-8" \
&&  groupadd -g "${gid}" "${USER}" \
&&  useradd -m -s /bin/zsh -u "${uid}" -g "${gid}" -c "ali@mustakim.com" -G dialout -p '$6$4XUjCfv1D9MC4RRh$JvANIuUtqK5aDNbHJMU0eCrlxg9TNnUpy3sYoK.jeCea0wdyjOH09uQublejMbsE83CcXTCSWK.x/LxvgJ4Pv0' "${USER}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"; fi \
&&  install -d -o "${uid}" -g "${gid}" -m 700 "/run/user/${uid}" \
#
# Modify configuration files
#
&&  chown -R ali /etc/xrdp/ \
&&  dirname $( readlink -f /etc/xrdp/key.pem ) | xargs chmod o+x \
&&  readlink -f /etc/xrdp/key.pem | xargs chmod +r \
&&  sed -i 's|LogFile=|LogFile=/tmp/|' /etc/xrdp/xrdp.ini \
&&  sed -i 's|LogFile=|LogFile=/tmp/|; s|#EnableFuseMount|EnableFuseMount|; s|param=.xorgxrdp|param=/tmp/.xorgxrdp|; s|FuseMountName=|FuseMountName=/tmp/|; /SessionVariables/aCHANSRV_LOG_PATH=\/tmp' /etc/xrdp/sesman.ini \
&&  sed -i 's|ERRFILE=$HOME|ERRFILE=\/tmp|' /etc/X11/Xsession
#
# ENTRYPOINT [ "/sbin/docker-init", "--", "/usr/bin/ttyd", "-p", "8081", "/usr/bin/tmux", "new", "-A", "-s", "ttyd" ]
# ENTRYPOINT /sbin/docker-init -- /usr/bin/ttyd -p 8081 /usr/bin/tmux new -A -s 'ttyd'

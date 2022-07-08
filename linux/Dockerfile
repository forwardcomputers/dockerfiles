#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
#
FROM debian:bullseye-backports
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
    uid="1001" \
    gid="1001" 
#
RUN set -e \
&&  export USER="${USER}" uid="${uid}" gid="${gid}" \
#
# Update repos and install packages
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
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
    ttyd/bullseye-backports \
    vim-tiny \
    \
    bash \
    bash-completion \
    zsh \
    zsh-common \
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
    #     docker-cli \
    #     docker-cli-compose \
    #     pinentry-curses \ for lastpass
    #     tzdata \
    #     lastpass-cli-bash-completion \
    #     lastpass-cli-zsh-completion && \
&&  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg \
&&  echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    docker-ce-cli \
    docker-compose-plugin \
#
# Install application
#
#
# Clean-up
#
&&  rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/*.log \
      /tmp/* \
#
# Create unprivileged user
#
&&  sed -i '/en_US.UTF/ s/^#//;s/^ *//' /etc/locale.gen \
&&  dpkg-reconfigure --frontend=noninteractive locales \
# &&  update-locale --no-checks LANG="en_US.UTF-8" \
# &&  locale-gen "en_US.UTF-8" \
&&  groupadd -g "${gid}" "${USER}" \
&&  useradd -m -s /bin/bash -u "${uid}" -g "${gid}" -c "ali@mustakim.com" -G dialout "${USER}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"; fi
#
#ENTRYPOINT [ "/sbin/docker-init", "--", "/usr/bin/ttyd", "-p", "8081", "/usr/bin/tmux", "new", "-A", "-s", "ttyd" ]
#ENTRYPOINT /sbin/docker-init -- /usr/bin/ttyd -p 8081 /usr/bin/tmux new -A -s 'ttyd'

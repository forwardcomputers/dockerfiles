#
# Based on the great efforts from both
# Home Assistant Visual Sudio Code add-on - https://github.com/hassio-addons/addon-vscode
# LinuxServer - https://github.com/linuxserver/docker-code-server
#
#APPNEW curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" | jq -r '.tag_name'
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
ENV user="duser" \
    uid="1001" \
    gid="1001" \
    LANG="C.UTF-8"
#
RUN set -e \
&&  export user="${user}" uid="${uid}" gid="${gid}" LANG="${LANG}" \
#
# Update Ubuntu repos and install dependencies
#
&&  rm -f /etc/dpkg/dpkg.cfg.d/excludes \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    jq \
    libarchive-tools \
    locales \
    openssh-client \
    tzdata \
    bind9-host \
    cups-bsd \
    docker.io \
    dnsutils \
    gawk \
    gnupg2 \
    expect \
    git \
    htop \
    iputils-ping \
    iproute2 \
    landscape-common \
    lastpass-cli \
    less \
    lsof \
    man \
    net-tools \
    openssh-server \
    powerline \
    sudo \
    tmux \
    traceroute \
    unzip \
    vim \
    wget \
    xz-utils \
    zip \
&&  dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | DEBIAN_FRONTEND=noninteractive xargs apt-get install --reinstall -y \
&&  rm -f /usr/bin/man \
&&  dpkg-divert --quiet --remove --rename /usr/bin/man \
#
# Install application
#
&&  APPNEW=$( curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" | jq -r '.tag_name' ) \
&&  APPURL=$( curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/tags/${APPNEW}" | jq -r '.assets[] | select(.browser_download_url | [contains("linux-amd64.tar.gz")][0]) | .browser_download_url' ) \
&&  curl -sL "${APPURL}" | tar xz -C /opt ; mv /opt/code-server* /opt/code-server \
#
&&  mkdir -p /opt/code-extensions \
&&  while read -r ext; do  \
        vendor="${ext%%.*}"; \
        slug="${ext#*.}"; \
        mkdir -p "/opt/code-extensions/${ext}"; \
        echo "Installing vscode extension: ${slug} by ${vendor}" && \
        while true; do \
            curl -sL --retry 5 "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${vendor}/vsextensions/${slug}/latest/vspackage" | bsdtar --strip-components=1 -xf - -C "/opt/code-extensions/${ext}" extension; \
            if [ $? -eq 0 ]; then break; fi \
        done; \
    done < /vscode.extensions \
&&  chown -R "${uid}":"${gid}" /opt/code-extensions \
#
# Clean-up
#
&&  rm -rf \
    /vscode.extensions \
    /etc/localtime \
    /usr/share/doc/* \
    /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb \
    /var/cache/apt/*.bin \
    /var/cache/debconf/*.old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/info/* \
    /var/log/apt \
    /var/log/*.log \
#
# Create unprivileged user
#
&&  locale-gen en_US.UTF-8 || true \
&&  groupadd -g "${gid}" "${user}" \
&&  useradd -m -s /bin/bash -u "${uid}" -g "${gid}" -G docker,lpadmin "${user}" \
&&  if [ ! -d /home/"${user}"/.ssh ]; then mkdir /home/"${user}"/.ssh; chmod 700 /home/"${user}"/.ssh; chown "${uid}":"${gid}" /home/"${user}"/.ssh; fi \
&&  curl -sL -o /home/"${user}"/.ssh/authorized_keys https://github.com/forwardcomputers.keys \
&&  chmod 600 /home/"${user}"/.ssh/authorized_keys; chown "${uid}":"${gid}" /home/"${user}"/.ssh/authorized_keys \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${user}"; fi \
#
&&  chmod -x /etc/update-motd.d/10-help-text /etc/update-motd.d/50-motd-news /etc/update-motd.d/60-unminimize \
&&  mkdir -p /etc/cups/ ; printf '%s\n' 'ServerName laser' > /etc/cups/client.conf \
#
&&  mkdir -p /run/sshd \
&&  sed 's/^#PermitRootLogin.*/PermitRootLogin no/; s/^#PasswordAuthentication.*/PasswordAuthentication no/' -i /etc/ssh/sshd_config \
&&  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
#
&&  mkdir -p /opt/filer \
&&  chmod 777 /opt/filer
#
EXPOSE 22/tcp 8080/tcp
ENTRYPOINT \
    DOCKER_HOST_GID="$(stat -c %g /var/run/docker.sock)" \
    DOCKER_CONTAINER_GID="$(awk -F':' '/docker/ {print $3}' < /etc/group)" \
    if [[ "${DOCKER_HOST_GID}" != "${DOCKER_CONTAINER_GID}" ]]; then \
        sudo sed -ie 's/'"${DOCKER_CONTAINER_GID}"'/'"${DOCKER_HOST_GID}"'/' /etc/group 2>/dev/null \
    fi \
    if [[ ! -d /home/"${user}"/.git ]]; then \
        cd /home/"${user}" \
        git clone -q --recursive https://github.com/forwardcomputers/dfiles.git tmp \
        mv tmp/.git . \
        rm -rf tmp/ .profile \
        git reset -q --hard \
        git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git \
        chown -R "${uid}":"${gid}" /home/"${user}" \
    fi \
    #
    setpriv --reuid="${uid}" --regid="${gid}" --init-groups --reset-env /opt/code-server/code-server --auth none --bind-addr 0.0.0.0:8080 --cert "/opt/filer/os/acme/*.home.mustakim.com/*.home.mustakim.com.cer" --cert-key "/opt/filer/os/acme/*.home.mustakim.com/*.home.mustakim.com.key" --disable-telemetry --extensions-dir /home/duser/.code-server/extensions/ --extra-builtin-extensions-dir /home/duser/.code-server/code-extensions/ --user-data-dir /home/duser/.code-server/data /home/duser & \
    #
    bash -c '/usr/sbin/sshd -De'


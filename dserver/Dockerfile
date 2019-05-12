#
#APPNEW 1.2
#DESKTOP_NAME Docker Server
#DESKTOP_COMMENT Linux server in Docker
#DESKTOP_CATEGORIES System;Utility;Network;
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://github.com/tmux/tmux/raw/master/logo/tmux-logomark.svg
#DOCKER_OPT = --rm --network=host --hostname=docker_"${NAME}" --volume /media:/media
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
ENV user="ali" \
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
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --reinstall --yes \
    bind9-host \
    ca-certificates \
    cups-bsd \
    curl \
    docker.io \
    dnsutils \
    gawk \
    gnupg2 \
    expect \
    git \
    htop \
    iputils-ping \
    iproute2 \
    jq \
    landscape-common \
    lastpass-cli \
    less \
    locales \
    lsof \
    man \
    net-tools \
    openssh-server \
    sudo \
    tmux \
    traceroute \
    unzip \
    vim \
    wget \
    xz-utils \
    zip \
&&  dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | DEBIAN_FRONTEND=noninteractive xargs apt-get -qq install --reinstall -y 2> /dev/null \
&&  rm -f /usr/bin/man \
&&  dpkg-divert --quiet --remove --rename /usr/bin/man \
#
# Clean-up
#
&&  rm --recursive --force \
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
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups docker,lpadmin --comment "${user}" "${user}" \
&&  if [ ! -d /home/"${user}"/.ssh ]; then mkdir /home/"${user}"/.ssh; chmod 700 /home/"${user}"/.ssh; chown "${uid}":"${gid}" /home/"${user}"/.ssh; fi \
&&  curl --silent --location --output /home/"${user}"/.ssh/authorized_keys --url https://github.com/forwardcomputers.keys \
&&  chmod 600 /home/"${user}"/.ssh/authorized_keys; chown "${uid}":"${gid}" /home/"${user}"/.ssh/authorized_keys \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${user}"; fi \
#
&&  chmod -x /etc/update-motd.d/10-help-text /etc/update-motd.d/50-motd-news /etc/update-motd.d/60-unminimize \
&&  mkdir -p /etc/cups/ ; printf '%s\n' 'ServerName laser' > /etc/cups/client.conf \
#
&&  mkdir -p /run/sshd \
&&  sed 's/^#Port 22/Port 3222/; s/^#PermitRootLogin.*/PermitRootLogin no/; s/^#PasswordAuthentication.*/PasswordAuthentication no/' -i /etc/ssh/sshd_config \
&&  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#
EXPOSE 3222
COPY entrypoint.sh /bin/entrypoint.sh
USER "${user}"
ENTRYPOINT [ "/bin/entrypoint.sh" ]
#
#APPNEW 1.0
#DESKTOP_NAME Docker Server
#DESKTOP_COMMENT Linux server in Docker
#DESKTOP_CATEGORIES System;Utility;Network;
#DESKTOP_MIMETYPES 
#DESKTOP_LOGO https://github.com/tmux/tmux/raw/master/logo/tmux-logomark.svg
#
FROM ubuntu:rolling
ARG REPO
ARG VERSION
ARG TEXT
#
LABEL maintainer="Ali Mustakim <alim@forwardcomputers.com>" \
      org.label-schema.name="${REPO}" \
      org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${REPO}" \
      BuildDate="${TEXT}"
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
    /var/log/*.log
#
# Create unprivileged user
#
RUN set -xe \
&&	locale-gen en_US.UTF-8 || true \
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups lpadmin --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi \
#
&&  chmod -x /etc/update-motd.d/10-help-text /etc/update-motd.d/50-motd-news /etc/update-motd.d/60-unminimize \
&&  mkdir -p /etc/cups/ ; printf '%s\n' 'ServerName laser' > /etc/cups/client.conf \
#
&&  mkdir -p /run/sshd \
&&  sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config \
&&  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#
USER "${user}" \
RUN set -xe \
&&  if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; chmod 700 ~/.ssh; fi \
&&  curl --silent --location --output ~/.ssh/authorized_keys --url https://github.com/forwardcomputers.keys \
&&  chmod 600 ~/.ssh/authorized_keys \
&&  git clone --recursive https://github.com/forwardcomputers/dfiles.git tmp \
&&  mv tmp/.git . \
&&  rm -rf tmp \
&&  git reset --hard \
&&  git remote set-url origin ssh://git@github.com/forwardcomputers/dfiles.git#
#
USER root
EXPOSE 3222
CMD [ "/usr/sbin/sshd", "-D" ]

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
ENV user="duser" \
	uid="1001" \
	gid="1001" \
	LANG="C.UTF-8"
#
RUN set -xe \
&&  export user="${user}" uid="${uid}" gid="${gid}" LANG="${LANG}" \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    bind9-host \
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
	libpulse0 \
	locales \
	lsof \
	net-tools \
	nfs-common \
	openssh-server \
	sudo \
	traceroute \
	vim \
#
# Clean-up
#
&&  rm --recursive --force \
	/usr/share/doc/* \
	/usr/share/man/* \
	/var/cache/apt/archives/*.deb \
	/var/cache/apt/archives/partial/*.deb \
	/var/cache/apt/*.bin \
	/var/cache/debcong/*.old \
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
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups audio,lpadmin,video --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi \
#
&&  rm /etc/update-motd.d/60-unminimize \
&&  mkdir -p /var/run/sshd \
&&  mkdir -p /etc/cups ; printf '%s\n' 'ServerName laser' > /etc/cups/client.conf \
&&  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
&&  sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config
#
USER "${user}"
WORKDIR /home/"${user}"
EXPOSE 3222
COPY entrypoint.sh /bin/entrypoint.sh
CMD [ "/bin/entrypoint.sh" ]

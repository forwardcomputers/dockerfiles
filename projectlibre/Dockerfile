#
#APPNEW curl --location --silent --url https://sourceforge.net/projects/projectlibre/files | perl -nle 'print $1 if /\/ProjectLibre\/(\K[^\/]+)/' | head -1
#DESKTOP_NAME ProjectLibre
#DESKTOP_COMMENT Free and open-source project management software 
#DESKTOP_CATEGORIES 
#DESKTOP_MIMETYPES 
#DESKTOP_LOGO 
#
FROM ubuntu:devel
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
RUN set -e \
&&  export user="${user}" uid="${uid}" gid="${gid}" LANG="${LANG}" \
#
# Update Ubuntu repos and install application
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
	libpulse0 \
	locales \
	ca-certificates \
	curl \
	openjdk-13-jre
#
# Install application
#
RUN set -e \
&&  appdeb=$( curl --location --silent --user-agent 'Mozilla/5.0 (X11; Linux x86_64; rv:9.0.1) Gecko/ /9.0.1' --url https://sourceforge.net/projects/projectlibre/files | \
	perl -nle 'print $1 if /\/ProjectLibre\/(\K[^d]+)/' | \
	head -1 ) \
&&  curl --location --output ./projectlibre.deb --silent --url https://sourceforge.net/projects/projectlibre/files/ProjectLibre/"${appdeb}"deb/download \
&&  dpkg --install ./projectlibre.deb \
&&  apt-get -qq install --fix-broken --no-install-recommends --yes \
#
# Clean-up
#
&&  apt-get -qq autoremove --yes \
&&  rm --recursive --force \
	./google-chrome.deb \
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
# Create unprivileged user
#
RUN set -e \
&&	locale-gen en_US.UTF-8 || true \
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups audio,video --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi
#
USER "${user}"
WORKDIR /home/"${user}"
ENTRYPOINT [ "projectlibre" ]

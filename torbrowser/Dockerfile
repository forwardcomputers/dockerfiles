#
#APPNEW curl --location --silent --url https://www.torproject.org/download | perl -nle 'print $1 if /linux64-(\K[^_]+)/' | head -1
#DESKTOP_NAME Tor browser
#DESKTOP_COMMENT Tor Browser is +1 for privacy and -1 for mass surveillance
#DESKTOP_CATEGORIES Network;WebBrowser;Security;
#DESKTOP_MIMETYPES 
#DESKTOP_LOGO https://gitweb.torproject.org/torbrowser.git/plain/build-scripts/branding/default48.png
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
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
	bzip2 \
	ca-certificates \
	curl \
	libavcodec-extra \
	libasound2 \
	libpulse0 \
	locales \
	xz-utils \
	adwaita-icon-theme-full \
	libatk1.0-0 \
	libc6 \
	libcairo-gobject2 \
	libcairo2 \
	libdbus-1-3 \
	libdbus-glib-1-2 \
	libfontconfig1 \
	libfreetype6 \
	libgcc1 \
	libgdk-pixbuf2.0-0 \
	libglib2.0-0 \
	libgtk-3-0 \
	libpango-1.0-0 \
	libpangocairo-1.0-0 \
	libstartup-notification0 \
	libstdc++6 \
	libx11-6 \
	libx11-xcb1 \
	libxcb-shm0 \
	libxcb1 \
	libxcomposite1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxrender1 \
	libxt6 \
	lsb-release \
	xul-ext-ubufox \
	libcanberra0 \
	libdbusmenu-glib4 \
	libdbusmenu-gtk3-4 \
	fonts-lyx \
#
# Clean-up
#
&&  rm --recursive --force \
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
# Install application
#
RUN set -e \
&&	appver=$( curl --location --silent --url https://www.torproject.org/projects/torbrowser.html.en | \
	tac | \
	awk -F'/' '/linux64/ { print $6; exit }' ) \
&&  curl --location --silent --url \
	https://www.torproject.org/dist/torbrowser/"${appver}"/tor-browser-linux64-"${appver}"_en-US.tar.xz | \
	tar --extract --xz --directory /opt \
&&  chown --recursive "${uid}:${gid}" /opt/tor-browser_en-US
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
ENTRYPOINT [ "/opt/tor-browser_en-US/Browser/start-tor-browser" ]

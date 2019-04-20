#
#APPNEW curl --location --silent --url https://omahaproxy.appspot.com/all | perl -nle 'print $1 if /linux,stable,(\K[^,]+)/'
#DESKTOP_NAME Google Chrome
#DESKTOP_COMMENT Access the Internet
#DESKTOP_CATEGORIES Network;WebBrowser;
#DESKTOP_MIMETYPES text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
#DESKTOP_LOGO https://github.com/forwardcomputers/dockerfiles/chrome/raw/master/chrome.png
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
	fonts-liberation \
	libappindicator3-1 \
	libasound2 \
	libatk-bridge2.0-0 \
	libatk1.0-0 \
	libatspi2.0-0 \
	libc6 \
	libcairo2 \
	libcups2 \
	libdbus-1-3 \
	libexpat1 \
	libgcc1 \
	libgdk-pixbuf2.0-0 \
	libglib2.0-0 \
	libgtk-3-0 \
	libnspr4 \
	libnss3 \
	libpango-1.0-0 \
	libpangocairo-1.0-0 \
	libuuid1 \
	libx11-6 \
	libx11-xcb1 \
	libxcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	lsb-release \
	wget \
	xdg-utils \
	libu2f-udev
#
# Install application
#
RUN set -e \
&&  curl --location --output ./google-chrome.deb --silent --url "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
&&  dpkg --install ./google-chrome.deb \
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
ENTRYPOINT [ "google-chrome-stable" ]

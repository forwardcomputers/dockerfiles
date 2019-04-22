#
#APPNEW curl --location --silent --url https://inkscape.org | perl -nle 'print $1 if /Current stable version: (\K[^<]+)/'
#DESKTOP_NAME Inkscape
#DESKTOP_COMMENT Create and edit Scalable Vector Graphics images
#DESKTOP_CATEGORIES Graphics;VectorGraphics;GTK;
#DESKTOP_MIMETYPES image/svg+xml;image/svg+xml-compressed;application/vnd.corel-draw;application/pdf;application/postscript;image/x-eps;application/illustrator;image/cgm;image/x-wmf;application/x-xccx;application/x-xcgm;application/x-xcdt;application/x-xsk1;application/x-xcmx;image/x-xcdr;application/visio;application/x-visio;application/vnd.visio;application/visio.drawing;application/vsd;application/x-vsd;image/x-vsd;
#DESKTOP_LOGO https://gitlab.com/inkscape/inkscape/raw/master/share/branding/inkscape.svg
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
	libpulse0 \
	locales \
	software-properties-common \
&&  add-apt-repository --yes ppa:inkscape.dev/stable \
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
	inkscape \
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
ENTRYPOINT [ "inkscape" ]

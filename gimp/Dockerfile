#
#APPNEW curl --silent --location --output - --url https://www.gimp.org | perl -nle 'print $1 if / DOWNLOAD <.+?>(\K[^<]+)/'
#DESKTOP_NAME GNU Image Manipulation Program
#DESKTOP_COMMENT Create images and edit photographs
#DESKTOP_CATEGORIES Graphics;2DGraphics;RasterGraphics;GTK;
#DESKTOP_MIMETYPES image/bmp;image/g3fax;image/gif;image/x-fits;image/x-pcx;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-psd;image/x-sgi;image/x-tga;image/x-xbitmap;image/x-xwindowdump;image/x-xcf;image/x-compressed-xcf;image/x-gimp-gbr;image/x-gimp-pat;image/x-gimp-gih;image/tiff;
#DESKTOP_LOGO https://gitlab.gnome.org/GNOME/gimp/raw/master/desktop/48x48/gimp.png
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
ENV user=duser \
	uid=1001 \
	gid=1001 \
	LANG=C.UTF-8
#
# Some docker tweaks
#
RUN set -xe \
&&  export user=${user} uid=${uid} gid=${gid} LANG=${LANG} \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
	libpulse0 \
	locales \
	gimp \
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
&&  groupadd --gid ${gid} ${user} \
&&  useradd --create-home --shell /bin/bash --uid ${uid} --gid ${gid} --groups audio,video --comment ${user} ${user} \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi
#
USER ${user}
WORKDIR /home/${user}
CMD [ "gimp" ]

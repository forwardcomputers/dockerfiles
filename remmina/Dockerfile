#
#APPNEW apt
#DESKTOP_NAME Remmina
#DESKTOP_COMMENT Connect to remote desktops
#DESKTOP_CATEGORIES GTK;GNOME;X-GNOME-NetworkSettings;Network;
#DESKTOP_MIMETYPE application/x-remmina;
#DESKTOP_LOGO https://gitlab.com/Remmina/Remmina/raw/master/data/desktop/scalable/apps/org.remmina.Remmina.svg
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
	remmina \
	remmina-plugin-rdp \
	remmina-plugin-vnc \
	remmina-plugin-xdmcp \
	avahi-daemon \
	dbus \
	dbus-x11 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
	netsurf \
	sudo \
#
# Disable IPv6 in Avahi
#
&&  sed 's/^#\?use-ipv6.*/use-ipv6=no/' -i /etc/avahi/avahi-daemon.conf \
#
# Add mimetypes
#
&&	printf '%s\n' \
		"[MIME Cache]" \
		"text/html=netsurf-gtk.desktop;" \
		"text/xml=netsurf-gtk.desktop;" \
		"x-scheme-handler/http=netsurf-gtk.desktop;" \
		"x-scheme-handler/https=netsurf-gtk.desktop;" > /usr/share/applications/mimeinfo.cache \
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
	/var/log/*.log \
#
# Create unprivileged user
#
&&	locale-gen en_US.UTF-8 || true \
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups audio,video --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi
#
USER "${user}"
WORKDIR /home/"${user}"
ENTRYPOINT [ "/bin/bash", "-c", "sudo service dbus restart && sudo service avahi-daemon restart && remmina" ]

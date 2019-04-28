#
#APPNEW apt
#DESKTOP_NAME Krita
#DESKTOP_COMMENT Digital Painting
#DESKTOP_CATEGORIES Qt;KDE;Graphics;
#DESKTOP_MIMETYPE application/x-krita;image/openraster;application/x-krita-paintoppreset;
#DESKTOP_LOGO https://raw.githubusercontent.com/KDE/krita/master/pics/calligrakrita-base.svg
##DOCKER_OPT + --security-opt apparmor=unconfined
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
    krita \
    ca-certificates \
    dbus-x11 \
    netsurf \
    python3-pyqt5 \
    python3-sip \
    qml-module-qtquick2 \
    subversion \
    xdg-utils \
&&  svn export https://github.com/adobe-fonts/source-sans-pro/trunk/TTF /usr/share/fonts/source-sans-pro \
&&  apt-get -qq purge \
    subversion \
#
# Add mimetypes
#
&&  printf '%s\n' \
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
&&  locale-gen en_US.UTF-8 || true \
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups audio,video --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi
#
USER "${user}"
WORKDIR /home/"${user}"
ENTRYPOINT [ "krita" ]

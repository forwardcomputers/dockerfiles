#
#APPNEW apt
#DESKTOP_NAME Blender
#DESKTOP_COMMENT 3D modeling, animation, rendering and post-production
#DESKTOP_CATEGORIES Graphics;3DGraphics;
#DESKTOP_MIMETYPE application/x-blender;
#DESKTOP_LOGO https://dev-files.blender.org/file/download/fkclrydgsqtfnb4jyjtf/PHID-FILE-etgo52x6ydb4mchv22xh/blender.svg
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
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    libpulse0 \
    locales \
    blender \
    netsurf \
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
ENTRYPOINT [ "blender" ]

#
#APPNEW curl --location --silent --url https://aur.archlinux.org/cgit/aur.git/plain/.SRCINFO?h=foxitreader | perl -nle 'print $1 if /pkgver = (\K[^ ]+)/'
#DESKTOP_NAME foxitreader
#DESKTOP_COMMENT View PDF documents
#DESKTOP_CATEGORIES Application;Office;Viewer;X-Red-Hat-Base;
#DESKTOP_MIMETYPE application/pdf;application/ppdf;
#DESKTOP_LOGO https://github.com/forwardcomputers/dockerfiles/raw/master/foxitreader/foxitreader.png
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
SHELL ["/bin/bash", "-c"]
RUN set -e \
&&  export user="${user}" uid="${uid}" gid="${gid}" LANG="${LANG}" \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    libpulse0 \
    locales \
    dbus-x11 \
    ca-certificates \
    curl \
    hicolor-icon-theme \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libfcitx-qt5-1 \
    libglib2.0-0 \
    libqt5core5a \
    libqt5dbus5 \
    libqt5gui5 \
    libqt5opengl5 \
    libqt5positioning5 \
    libqt5printsupport5 \
    libqt5qml5 \
    libqt5quickwidgets5 \
    libqt5sensors5 \
    libqt5sql5 \
    libqt5webkit5 \
    libqt5xml5 \
    libqt5xmlpatterns5 \
    libstdc++6 \
    libgstreamer-plugins-base1.0-0 \
    libxcomposite1 \
    libxslt1.1 \
    libxrender1 \
    netsurf \
    p7zip-full \
    yelp \
    xdg-utils \
#
# Install application
# Done with the help from the arch repository @ https://aur.archlinux.org/packages/foxitreader/
#
&&  mkdir --parents /opt/foxittemp \
&&  cd /opt/foxittemp \
&&  curl --location --silent --url \
    $( curl --location --silent --url https://aur.archlinux.org/cgit/aur.git/plain/.SRCINFO?h=foxitreader | perl -nle 'print $1 if /source = (\K[^ ]+)/' | head -1 ) | \
    tar --extract -z --to-stdout > foxitreader.run \
&&  grep --only-matching --byte-offset --binary --text $'7z\xBC\xAF\x27\x1C' foxitreader.run | \
    cut -f1 -d: | \
    while read _position ; \
    do \
        dd if=foxitreader.run bs=1M iflag=skip_bytes status=none skip="${_position}" of="bin-${_position}.7z" ; \
    done \
&&  install --mode=755 -d /opt/foxitreader \
&&  for _file in *.7z ; \
    do \
       7z -bd -bb0 -y x -o"/opt/foxitreader" "${_file}" 1>/dev/null 2>&1 || true ; \
    done \
&&  rm --recursive --force /opt/foxittemp \
&&  cd /opt/foxitreader \
&&  rm --force "Activation" "Activation.desktop" "Activation.sh" \
     "countinstalltion" "countinstalltion.sh" \
     "installUpdate" "ldlibrarypath.sh" \
     "maintenancetool.sh" "Uninstall.desktop" \
     "Update.desktop" "updater" "updater.sh" \
&&  find -type d -name ".svn" -exec rm -rf {} + \
&&  find -type f -name ".directory" -exec rm -rf {} + \
&&  find -type f -name "*~" -exec rm {} + \
&&  curl --location --silent --url https://aur.archlinux.org/cgit/aur.git/plain/foxitreader-excluded_files?h=foxitreader |  \
    while IFS='' read -r _line ; \
    do \
        if [ -n "${_line}" -a "${_line::1}" != "#" ] ; then echo rm --force "${_line}" ; fi ; \
    done \
&&  rm --force "lib/libstdc++.so.6" \
&&  printf '%s\n' \
    "selfpath="FoxitReader" \
    "selfpath="/opt/foxitreader" \
    "export LD_LIBRARY_PATH=${selfpath}/lib:${selfpath}/platforms:${selfpath}/printsupport:${selfpath}/rmssdk:${selfpath}/sensors:${selfpath}/imageformats:${selfpath}/platforminputcontexts" \
    'exec "$selfpath/$appname" "$@"' > /opt/foxitreader/FoxitReader.sh \
#
# Add mimetypes
#
&&	printf '%s\n' \
    "[MIME Cache]" \
    "x-scheme-handler/ghelp=yelp.desktop;" \
    "x-scheme-handler/help=yelp.desktop;" \
    "x-scheme-handler/info=yelp.desktop;" \
    "x-scheme-handler/man=yelp.desktop;" \
    "application/xhtml+xml=netsurf-gtk.desktop;" \
    "application/xml=netsurf-gtk.desktop;" \
    "text/html=netsurf-gtk.desktop;" \
    "text/xml=netsurf-gtk.desktop;" \
    "x-scheme-handler/chrome=netsurf-gtk.desktop;" \
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
ENTRYPOINT [ "/opt/foxitreader/FoxitReader" ]

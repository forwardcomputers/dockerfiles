#
#APPNEW curl --location --silent --url https://www.ganttproject.biz/download/upgrade#linux | grep '/lin' | perl -nle 'print $1 if /\/dl\/(\K[^\/]+)/'
#DESKTOP_NAME GanttProject
#DESKTOP_COMMENT Project Management
#DESKTOP_CATEGORIES Office;
#DESKTOP_MIMETYPE application/x-ganttproject;
#DESKTOP_LOGO https://github.com/bardsoftware/ganttproject/raw/master/ganttproject-builder/ganttproject.svg
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
	openjdk-11-jre \
	libcanberra-gtk-module \
    libcanberra-gtk3-module 

#
# Install application
#
RUN set -e \
&&  appdeb=$( curl --location --silent --url https://www.ganttproject.biz/download/upgrade#linux | \
	grep '/lin' | \
	perl -nle 'print $1 if /\/dl\/(\K[^\/]+)/' ) \
&&  curl --location --output ./ganttproject.deb --silent --url https://www.ganttproject.biz/dl/"${appdeb}"/lin \
&&  dpkg --install ./ganttproject.deb \
&&  apt-get -qq install --fix-broken --no-install-recommends --yes \
#
# Clean-up
#
&&  apt-get -qq autoremove --yes \
&&  rm --recursive --force \
	./ganttproject.deb \
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
ENTRYPOINT [ "/usr/bin/ganttproject" ]

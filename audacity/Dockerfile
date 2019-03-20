#
#APPNEW curl --location --header '"${GH_AUTH_HEADER}"' --header '"${GH_API_HEADER}"' --silent --url https://api.github.com/repos/audacity/audacity/releases/latest | jq -r '.tag_name | split("-")[1]'
#DESKTOP_NAME Audacity
#DESKTOP_COMMENT Record and edit audio files
#DESKTOP_CATEGORIES AudioVideo;Audio;AudioVideoEditing;
#DESKTOP_MIMETYPES application/x-audacity-project;
#DESKTOP_LOGO https://github.com/audacity/audacity/raw/master/images/AudacityLogo.png
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
RUN set -xe \
&&  export user="${user}" uid="${uid}" gid="${gid}" LANG="${LANG}" \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
	libpulse0 \
	locales \
	software-properties-common \
&&  add-apt-repository --yes ppa:ubuntuhandbook1/audacity \
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
	audacity \
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
RUN set -xe \
&&	locale-gen en_US.UTF-8 || true \
&&  groupadd --gid "${gid}" "${user}" \
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --groups audio,video --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/duser; fi
#
USER "${user}"
WORKDIR /home/"${user}"
CMD [ "audacity" ]

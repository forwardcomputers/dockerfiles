#
#APPNEW curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" | jq -r '.tag_name'
#
FROM ubuntu:rolling
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/master/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
ENV user="ali" \
    uid="1001" \
    gid="1001" \
    HOME="/home/ali"
#
COPY vscode.extensions /vscode.extensions
#
RUN set -e \
&&  export user="${user}" uid="${uid}" gid="${gid}" \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lastpass-cli \
    libarchive-tools \
    locales \
    net-tools \
    openssh-client \
    sudo \
    tzdata \
    > /dev/null \
#
# Install s6
#
&&  APPNEW=$( curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | jq -r '.tag_name' ) \
&&  APPURL=$( curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/tags/${APPNEW}" | jq -r '.assets[] | select(.browser_download_url | endswith("amd64.tar.gz")) | .browser_download_url' ) \
&&  curl -s -L -o /tmp/s6 "${APPURL}" \
&&  tar xzhf /tmp/s6 -C / --exclude=usr/bin/execlineb \
&&  tar xzhf /tmp/s6 -C /usr ./bin/execlineb \
&&  $_clean \
#
# Install application
#
&&  APPNEW=$( curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" | jq -r '.tag_name' ) \
&&  APPURL=$( curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/tags/${APPNEW}" | jq -r '.assets[] | select(.browser_download_url | contains("linux-x86_64")) | .browser_download_url' ) \
&&  curl -s -L "${APPURL}" | tar xz -C /opt ; mv /opt/code-server* /opt/code-server \
#
&&  mkdir -p /opt/code-extensions \
&&  chown "${uid}":"${gid}" /opt/code-extensions \
&&  while read -r ext; do  \
        vendor="${ext%%.*}"; \
        slug="${ext#*.}"; \
        mkdir -p "/opt/code-extensions/${ext}"; \
        echo "Installing vscode extension: ${slug} by ${vendor}" && \
        while [ $? -ne 0 ]; do \
            curl -qL --retry 5 "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${vendor}/vsextensions/${slug}/latest/vspackage" | bsdtar --strip-components=1 -xf - -C "/opt/code-extensions/${ext}" extension; \
        done; \
        sleep 10; \
    done < /vscode.extensions \
#
# Clean-up
#
&&  rm --recursive --force \
    /vscode.extensions \
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
&&  useradd --create-home --shell /bin/bash --uid "${uid}" --gid "${gid}" --comment "${user}" "${user}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${user}"; fi \
&&  mkdir -p /opt/filer \
&&  chmod 777 /opt/filer
#
COPY /root /
EXPOSE 8443
ENTRYPOINT ["/init"]

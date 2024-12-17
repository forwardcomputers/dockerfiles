#
#APPNEW apt
#DESKTOP_NAME Cockpit
#DESKTOP_COMMENT Cockpit system manager
#DESKTOP_CATEGORIES 
#DESKTOP_MIMETYPE 
#DESKTOP_LOGO https://github.com/cockpit-project/cockpit/raw/master/src/branding/default/logo.svg
##DOCKER_OPT + --priviliged
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
RUN set -e \
#
# Update Ubuntu repos and install dependencies
#
&&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    cockpit-bridge \
    cockpit-dashboard \
    cockpit-docker \
    cockpit-machines \
    cockpit-networkmanager \
    cockpit-packagekit \
    cockpit-psp \
    cockpit-storaged \
    cockpit-system \
    cockpit-ws \
    systemd \
    systemd-sysv \
#
# Clean-up
#
&&  ls -d /lib/systemd/system/sysinit.target.wants/* | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
&&  rm --recursive --force \
    /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp* \
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
&&  echo "root:cockpit" | chpasswd \
&&  mkdir -p /root/.local/share/cockpit \
&&  printf "[WebService]\nAllowUnencrypted=true\n" > /etc/cockpit/cockpit.conf

EXPOSE 9090
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/lib/systemd/systemd"]

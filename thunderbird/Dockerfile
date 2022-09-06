#
#APPNEW 1.0
#PLATFORM --platform=linux/amd64,linux/arm64
#
FROM debian:latest
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
ARG DEBIAN_FRONTEND=noninteractive
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
# Update repos and install packages
#
RUN apt-get update && apt-get -y full-upgrade && apt-get -y install \
    thunderbird \
#
# Clean-up
#
&&  rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/journal \
      /var/log/*.log \
      /tmp/* \
#
# Modify configuration files
#
#
# ENTRYPOINT [ "/sbin/docker-init", "--", "/usr/bin/ttyd", "-p", "8081", "/usr/bin/tmux", "new", "-A", "-s", "ttyd" ]
# ENTRYPOINT /sbin/docker-init -- /usr/bin/ttyd -p 8081 /usr/bin/tmux new -A -s 'ttyd'


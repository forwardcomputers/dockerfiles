#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
#
FROM alpine:latest

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
#
RUN set -e \
#
# Update repos and install packages
#
&&  echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community"  >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main"       >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/testing"    >> /etc/apk/repositories \
&&  apk --update --no-cache add \
    dosfstools \
    e2fsprogs \
    eudev \
    qemu-img \
    git \
    rsync \
    sfdisk \
#
&&  git clone https://github.com/alpinelinux/alpine-make-vm-image \
#
# Clean-up
#
&&  rm -rf \
    /var/cache/apk \
    /var/lib/apk
#
ENTRYPOINT [ "/bin/sh" ]

#
#APPNEW curl -sL "https://api.github.com/repos/nicolargo/glances/releases/latest" | jq -r '.tag_name[1:]'
#
# Alpine image
FROM python:alpine
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
# Install dependencies
#
RUN apk -u --no-cache add \
    git \
    gcc \
    musl-dev \
    linux-headers \
    wireless-tools \
    zeromq-dev \
#
# Install application
#
&&  DEPS="setuptools glances[action,batinfo,browser,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]" \
&&  pip install --no-cache-dir --upgrade pip \
&&  pip install --no-cache-dir $DEPS \
&&  pip install --no-cache-dir glances \
&&  apk del \
    gcc \
    musl-dev \
    linux-headers \
    zeromq-dev \
#
# Clean-up
#
&& rm -rf \
   /etc/apk \
   /lib/apk \
   /sbin/apk \
   /usr/share/apk \
   /var/lib/apk
#
EXPOSE 61208/tcp 61209/tcp
WORKDIR /glances
ENTRYPOINT python3 -m glances -C /glances/conf/glances.conf $GLANCES_OPT

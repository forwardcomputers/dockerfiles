#
#APPNEW curl -sL "https://api.github.com/repos/duplicati/duplicati/releases" | jq -r 'first ( .[] | select( .tag_name | contains( "beta" ) ).tag_name )[1:]'
#
FROM mono:6-slim
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
# Install apps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y install \
    curl \
    jq \
    libarchive-tools \
    mono-complete \
    libmono-sqlite4.0-cil \
    libmono-system-drawing4.0-cil \
    libmono-system-net-http-webrequest4.0-cil \
    libmono-system-web4.0-cil \
    referenceassemblies-pcl \
#
&&  APPNEW=$( curl -sX GET "https://api.github.com/repos/duplicati/duplicati/releases" | \
                jq -r 'first( .[] | select( .tag_name | contains( "beta" ) ).tag_name )' ) \
&&  APPURL=$( curl -sX GET "https://api.github.com/repos/duplicati/duplicati/releases/tags/${APPNEW}" | \
                jq -r '.assets[] | select( .browser_download_url | ( contains( ".zip" ) and ( contains( "signatures" ) | not ) ) ) | .browser_download_url' ) \
&&  mkdir -p /opt/duplicati \
&&  curl -sL "${APPURL}" | bsdtar -xf- -C /opt/duplicati \
#
&&  sed -i 's#mozilla/DST_Root_CA_X3.crt#!mozilla/DST_Root_CA_X3.crt#' /etc/ca-certificates.conf \
&&  update-ca-certificates \
#
# Clean-up
&&  rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/*.log
#
EXPOSE 8200


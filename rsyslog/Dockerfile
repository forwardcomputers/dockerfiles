#
#APPNEW apt
#
FROM debian:latest
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
#
LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-url="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.label-schema.vendor="${CO}" \
        org.label-schema.version="${APPNEW}" \
        org.label-schema.url="https://hub.docker.com/r/forwardcomputers/${NAME}" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.title="${NAME}" \
        org.opencontainers.image.source="https://github.com/forwardcomputers/dockerfiles/tree/main/${NAME}" \
        org.opencontainers.image.vendor="${CO}" \
        org.opencontainers.image.version="${APPNEW}" \
        org.opencontainers.image.url="https://hub.docker.com/r/forwardcomputers/${NAME}"
#
# Install apps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y install \
    libphp-jpgraph \
    php \
&&  apt-get -y --no-install-recommends install \
    apache2 \
    cron \
    jq \
    rsyslog \
    logrotate \
    wget \
    procps \
    vim \
#
#loganalyzer
&&  cd /var/www \
&&  rm -rf html \
&&  mkdir -p /tmp/loganalyzer \
&&  LATEST=$( wget -q -O - "https://api.github.com/repos/rsyslog/loganalyzer/releases/latest" | jq -r '.tag_name' ) \
&&  wget -q -O - "https://github.com/rsyslog/loganalyzer/archive/refs/tags/${LATEST}.tar.gz" | tar -xzf - --strip-components=1 -C /tmp/loganalyzer \
&&  mv /tmp/loganalyzer/src html \
&&  touch html/config.php \
&&  chmod 666 html/config.php \
#
# #Pimp My Log
# &&  cd /var/www \
# &&  rm -rf html \
# &&  wget -q -O - https://github.com/potsky/PimpMyLog/tarball/master | tar xzf - \
# &&  mv potsky-PimpMyLog-* html \
#
&&  echo "America/Toronto" > /etc/timezone \
#
# Clean-up
&&  rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /var/lib/apt \
      /var/lib/dpkg/info \
      /var/log/apt \
      /var/log/*.log \
      /tmp/*
#
CMD [ "/bin/sh", "-c" , "service cron restart && rm -f /run/apache2/apache2.pid && apache2ctl -D FOREGROUND && rm -f /run/rsyslogd.pid && rsyslogd -n & tail -f /dev/null" ]

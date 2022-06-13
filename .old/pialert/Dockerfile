#
#APPNEW curl -sL "https://api.github.com/repos/pucherot/Pi.Alert/releases/latest" | jq -r '.tag_name'
#
# Alpine image
FROM ubuntu:latest
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
ENV DEBIAN_FRONTEND noninteractive
RUN echo '>>>>> Install packages' \
&&  set -e \
&&  apt-get update -qq && apt-get install --no-install-recommends -qq -y \
    arp-scan \
    ca-certificates \
    cron \
    curl \
    dnsutils \
    iproute2 \
    lighttpd \
    net-tools \
    php \
    php-cgi \
    php-fpm \
    php-sqlite3 \
    python3 \
    sqlite3 \
    sudo \
    vim-tiny \
#    apt-utils \
#
&&  echo '>>>>> Install application' \
&&  curl -sL "https://github.com/pucherot/Pi.Alert/raw/main/tar/pialert_latest.tar" | \
    tar -xC /opt \
        --exclude='pialert/config/pialert.conf' \
        --exclude='pialert/db' \
        --exclude='pialert/docs' \
        --exclude='pialert/install/*.html' \
        --exclude='pialert/install/*.conf' \
        --exclude='pialert/install/*.sh' \
#
&&  echo '>>>>> Clean-up files' \
&&  rm --recursive --force \
    /usr/share/doc/* \
    /usr/share/man/* \
    /var/lib/apt/lists/* \
    /var/log/apt \
    /var/log/*.log \
#
&& echo '>>>>> Configure application'
RUN rm -f /var/www/html/index.lighttpd.html \
&&  ln -s /opt/pialert/install/index.html /var/www/html/index.html \
&&  ln -s /opt/pialert/front /var/www/html/pialert  \
&&  sed -i -r ' \
        s!env python$!env python3! ; \
        /smtp_connection.login/ s!^!#! \
    ' /opt/pialert/back/pialert.py \
&&  sed -i -r ' \
        s!python !python3 !g ; \
        s!~/pialert!/opt/pialert!g \
    ' /opt/pialert/install/pialert.cron \
&&  lighttpd-enable-mod fastcgi-php \
&&  sed -i '/^include_shell/ a\\ninclude_shell "cat external.conf 2>/dev/null"\n' /etc/lighttpd/lighttpd.conf \
&&  ( crontab -l 2>/dev/null; cat /opt/pialert/install/pialert.cron ) | crontab -
#
CMD [ "/bin/sh", "-c" , "service lighttpd start & service cron start & tail -f /dev/null" ]

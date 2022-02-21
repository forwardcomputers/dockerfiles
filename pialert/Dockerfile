#
#APPNEW curl -sL "https://api.github.com/repos/pucherot/Pi.Alert/releases/latest" | jq -r '.tag_name'
#
# Alpine image
FROM alpine:latest
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
RUN echo '>>>>> Install packages' \
&&  apk update -f && apk --no-cache add -f \
    lighttpd \
    php \
    php-cgi \
    php-fpm \
    php-json \
    php-sqlite3 \
    sqlite \
    perl-libwww \
    python3 \
    cronie \
    curl \
    bind-tools \
    sudo \
&&  apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing arp-scan \
#
&&  echo '>>>>> Install application' \
&&  wget -qO- https://github.com/pucherot/Pi.Alert/raw/main/tar/pialert_latest.tar | \
    tar -xC /opt \
        --exclude='pialert/config/pialert.conf' \
        --exclude='pialert/db' \
        --exclude='pialert/docs' \
        --exclude='pialert/install/*.html' \
        --exclude='pialert/install/*.conf' \
        --exclude='pialert/install/*.sh' \
#
&&  echo '>>>>> Clean-up files' \
&& rm -rf \
    /etc/apk \
    /lib/apk \
    /sbin/apk \
    /usr/share/apk \
    /usr/share/man \
    /var/cache/apk \
    /var/lib/apk \
#
&& echo '>>>>> Configure application'
RUN mkdir -p /var/run/php-fpm7 \
&&  sed -i -r ' \
        s|env python$|env python3| ;\
        /smtp_connection.login/ s|^|#| \
    ' /opt/pialert/back/pialert.py \
&&  sed -i -r ' \
        s|python |python3 |g ; \
        s|~/pialert|/opt/pialert|g \
    ' /opt/pialert/install/pialert.cron \
&&  sed -i -r ' \
        s|var/www/localhost|opt/pialert/front|g ; \
        /mod_alias/ s|^#||g ; \
        /mod_cgi.conf/ s|^#||g ; \
        /mod_fastcgi_fpm.conf/ s|^#||g ; \
        /^server.document-root/ s|var.basedir.*$|var.basedir|g ; \
        /linux-sysepoll/ s|^#||g ; \
        s|^.*server.port.*$|server.port = 20211|g \
    ' /etc/lighttpd/lighttpd.conf \
&&  sed -i -r ' \
        s|^.*listen =.*|listen = /var/run/php-fpm7/php7-fpm.sock|g ; \
        s|^.*listen.owner =.*|listen.owner = lighttpd|g ; \
        s|^.*listen.group =.*|listen.group = lighttpd|g ; \
        s|^.*listen.mode =.*|listen.mode = 0660|g \
    ' /etc/php*/php-fpm.d/www.conf \
&&  ( crontab -l 2>/dev/null; cat /opt/pialert/install/pialert.cron ) | crontab - \
#
&& echo -e '\
server.modules += ( "mod_fastcgi" ) \n\
index-file.names += ( "index.php" ) \n\
fastcgi.server = ( \n\
  ".php" => ( \n\
    "localhost" => ( \n\
      "socket"                => "/var/run/php-fpm7/php7-fpm.sock", \n\
      "broken-scriptfilename" => "enable" \n\
    ) \n\
  ) \n\
)\
' > /etc/lighttpd/mod_fastcgi_fpm.conf
#
EXPOSE 80
CMD [ "/bin/sh", "-c" , "/usr/sbin/php-fpm7 & /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf" ]
#CMD [ "/bin/sh", "-c" , "/usr/sbin/php-fpm7 & /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf & tail -f /dev/null" ]

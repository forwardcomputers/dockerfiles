#
#APPNEW curl -sL "https://api.github.com/repos/acmesh-official/acme.sh/releases/latest" | jq -r '.tag_name'
#DOCKER_OPT + -v "${HOME}"/acme:/acme.sh
#dDOCKER_OPT + -e GD_Key="$(lpass show LP_GODADDY --username)" -e GD_Secret="$(lpass show LP_GODADDY --password)" -v "${HOME}"/acme:/acme.sh
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
# Install application
#
RUN apk update -f && apk --no-cache add -f \
    bind-tools \
    coreutils \
    curl \
    oath-toolkit-oathtool \
    openssh-client \
    openssl \
    socat \
    tar \
    tini \
    tzdata \
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
ENV LE_CONFIG_HOME /acme.sh
ENV AUTO_UPGRADE 1
#Install
ADD ./ /install_acme.sh/
RUN cd /install_acme.sh && ([ -f /install_acme.sh/acme.sh ] && /install_acme.sh/acme.sh --install --config-home /acme.sh || curl https://get.acme.sh | sh) && rm -rf /install_acme.sh/ \
#&&  mv /root/.acme.sh / \
#&&  chmod 755 /.acme.sh \
&&  ln -s  /root/.acme.sh/acme.sh  /usr/local/bin/acme.sh && crontab -l | grep acme.sh | sed 's#> /dev/null##' | crontab - \
&&  for verb in help \
  version \
  install \
  uninstall \
  upgrade \
  issue \
  signcsr \
  deploy \
  install-cert \
  renew \
  renew-all \
  revoke \
  remove \
  list \
  showcsr \
  install-cronjob \
  uninstall-cronjob \
  cron \
  toPkcs \
  toPkcs8 \
  update-account \
  register-account \
  create-account-key \
  create-domain-key \
  createCSR \
  deactivate \
  deactivate-account \
  set-notify \
  ; do \
    printf -- "%b" "#!/usr/bin/env sh\n/usr/local/bin/acme.sh --${verb} --config-home /acme.sh \"\$@\"" >/usr/local/bin/--${verb} && chmod +x /usr/local/bin/--${verb} \
  ; done
#
VOLUME /acme.sh
WORKDIR /acme.sh

SHELL ["/bin/sh", "-c"]

ENTRYPOINT \
    set -- "$0" "$@"; \
    if [ "$1" = "daemon" ]; then \
        # insert a crontab entry to run every hour, starting an hour from now
        echo "$(( $(date +%-M -d 'now') + 1 )) 0 * * * acme.sh --cron" | tee /dev/stderr | crontab -; \
        exec /sbin/tini -- crond -f -d6; \
    else \
        exec -- acme.sh "$@"; \
    fi
#
CMD ["--help"]

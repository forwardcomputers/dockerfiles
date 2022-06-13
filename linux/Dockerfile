#
#APPNEW 1.0
#
FROM alpine:edge
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
    tz="America/Toronto"
#
RUN set -e && \
    export user="${user}" uid="${uid}" gid="${gid}" tz="${tz}" && \
#
# Update repos and install packages
#
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"  >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"       >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"    >> /etc/apk/repositories && \
    apk add --no-cache --update \
        bash \
        busybox-extras \
        ca-certificates \
        curl \
        docker-cli \
        docker-compose \
        file \
        jq \
        openssh-client \
        gawk \
        git \
        lastpass-cli \
        sudo \
        ttyd \
        tzdata \
        bash-completion \
        docker-bash-completion \
        docker-compose-bash-completion \
        git-bash-completion \
        lastpass-cli-bash-completion \
        util-linux-bash-completion && \
    cp /usr/share/zoneinfo/"${tz}" /etc/localtime && \
    echo "${tz}" > /etc/timezone && \
#
# Install application
#
    curl -sLo /usr/local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64 && \
    chmod +x /usr/local/bin/powerline-go && \
    echo $'function _update_ps1() { \n\
  PS1="$(/usr/local/bin/powerline-go -colorize-hostname -error 0)" \n\
} \n\
if [ "$TERM" != "linux" ] && [ -f "/usr/local/bin/powerline-go" ]; then \n\
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND" \n\
fi' > /etc/profile.d/powerline-go.sh && \
#
# Clean-up
#
   apk del tzdata && \
   rm -rf \
    /var/cache/apk \
    /var/lib/apk
#
# Create unprivileged user
#
#     locale-gen en_US.UTF-8 || true && \
RUN addgroup -g "${gid}" "${user}" && \
    adduser -s /bin/bash -u 1001 -D -g "${user}" -G "${user}" "${user}" && \
    if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${user}"; fi
#
ENTRYPOINT /usr/bin/ttyd -p 8081 -t fontSize=11 -t fontFamily="DejaVu Sans Mono for Powerline" /bin/bash


#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
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
        busybox-extras \
        ca-certificates \
        curl \
        docker-cli \
        docker-cli-compose \
        file \
        grep \
        inetutils-ftp \
        jq \
        openssh-client \
        gawk \
        git \
        lastpass-cli \
        p7zip \
        sudo \
        tini \
        ttyd \
        tzdata \
        xz \
        zsh \
        oh-my-zsh \
        docker-zsh-completion \
        git-zsh-completion \
        lastpass-cli-zsh-completion && \
#
    cp /usr/share/zoneinfo/"${tz}" /etc/localtime && \
    echo "${tz}" > /etc/timezone && \
#
# Install application
#
#
# Clean-up
#
    apk del tzdata && \
    rm -rf \
     /var/cache/apk \
     /var/lib/apk && \
#
# Create unprivileged user
#
    addgroup -g "${gid}" "${user}" && \
    adduser -s /bin/bash -u 1001 -D -g "${user}" -G "${user}" "${user}" && \
    if [ -d "/etc/sudoers.d" ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${user}"; fi
#
ENTRYPOINT [ "tini", "-v", "--", "/usr/bin/ttyd", "-s", "SIGKILL", "-p", "8081", "/bin/zsh" ]


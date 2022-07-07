#
#APPNEW curl -sL "https://mirror.csclub.uwaterloo.ca/alpine/latest-stable/releases/x86_64/latest-releases.yaml" | yq e '.[0].version'
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
ENV USER="ali" \
    uid="1001" \
    gid="1001"
#
RUN set -e \
&&  export USER="${USER}" uid="${uid}" gid="${gid}" \
#
# Update repos and install packages
#
# &&  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
#     apt-transport-https \
#     ca-certificates \
#     coreutils \
    # apk add --no-cache --update \
    #     busybox-extras \
    #     ca-certificates \
    #     coreutils \
    #     curl \
    #     docker-cli \
    #     docker-cli-compose \
    #     file \
    #     findutils \
    #     grep \
    #     inetutils-ftp \
    #     jq \
    #     openssh-client \
    #     gawk \
    #     git \
    #     lastpass-cli \
    #     p7zip \
    #     sudo \
    #     tmux \
    #     tzdata \
    #     ttyd \
    #     xz \
    #     bash \
    #     lastpass-cli-bash-completion \
    #     zsh \
    #     zsh-vcs \
    #     lastpass-cli-zsh-completion && \
#
# Install application
#
#
# Clean-up
#
# &&  rm -rf \
#       /usr/share/doc \
#       /usr/share/man \
#       /var/lib/apt \
#       /var/lib/dpkg/info \
#       /var/log/apt \
#       /var/log/*.log \
#       /tmp/* \
#
# Create unprivileged user
#
&&  addgroup -g "${gid}" "${USER}" \
&&  adduser -s /bin/zsh -u 1001 -D -g "ali@mustakim.com" -G "${USER}" "${USER}" \
&&  adduser ali dialout \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"; fi
#
#ENTRYPOINT [ "/sbin/docker-init", "--", "/usr/bin/ttyd", "-p", "8081", "/usr/bin/tmux", "new", "-A", "-s", "ttyd" ]
#ENTRYPOINT /sbin/docker-init -- /usr/bin/ttyd -p 8081 /usr/bin/tmux new -A -s 'ttyd'

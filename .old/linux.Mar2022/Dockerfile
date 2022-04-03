FROM debian:latest

ENV USER="ali" \
    UID="1001" \
    GID="1001" \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

RUN set -ex; \
    apt-get update && apt-get -y install --no-install-recommends \
      bash \
      curl \
      dnsutils \
      docker.io \
      docker-compose \
      feh \
      fluxbox \
      gawk \
      git \
      iputils-ping \
      iproute2 \
      jq \
      lastpass-cli \
      less \
      libarchive-tools \
      man \
      net-tools \
      novnc \
      openssh-client \
      powerline \
      rxvt-unicode \
      sudo \
      supervisor \
      unzip \
      vim \
      x11-xserver-utils \
      x11vnc \
      xvfb \
      xz-utils \
      zip

# Create unprivileged USER
RUN groupadd -g "${GID}" "${USER}" && \
    useradd -m -s /bin/bash -u "${UID}" -g "${GID}" -G "docker,${USER}" "${USER}" && \
    if [ -d "/etc/sudoers.d" ]; then echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"; fi

COPY . /app
CMD ["/app/entrypoint.sh"]
EXPOSE 8080

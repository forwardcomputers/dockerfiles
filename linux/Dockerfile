#
#APPNEW 1.0
#
# FROM debian:testing
FROM forwardcomputers/base_debian
ARG BUILD_DATE
ARG NAME
ARG CO
ARG APPNEW
ARG DEBIAN_FRONTEND=noninteractive
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
RUN set -e \
#
# Update repos and install packages
#
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    apt-utils \
    busybox \
    bzip2\
    ca-certificates \
    coreutils \
    curl \
    file \
    findutils \
    grep \
    iproute2 \
    ftp \
    net-tools \
    gnupg \
    jq \
    less \
    openssh-client \
    gawk \
    git \
    gzip \
    lastpass-cli \
    locales \
    lsb-release \
    openssh-server \
    p7zip-full \
    procps \
    psmisc \
    sudo \
    tmux \
    unzip \
    vim-tiny \
    xz-utils \
    \
    bash \
    bash-completion \
    zsh \
    zsh-common \
    \
    hsetroot \
    openbox \
    lxterminal \
    novnc \
    tint2 \
    x11vnc \
    xorgxrdp \
    xrdp \
    x11-xserver-utils \
    xvfb \
#
#    supervisor \
#
&&  apt-get -y install \
    firefox-esr \
    libpci3 \
#
&&  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg \
&&  echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
         bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
&&  apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    docker-ce-cli \
    docker-compose-plugin \
#
# Install application
#
&&  TTYDNEW=$(curl -sL "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | jq -r '.tag_name') \
&&  curl -sLo /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/${TTYDNEW}/ttyd.x86_64" \
&&  chmod +x /usr/local/bin/ttyd \
#
# Clean-up
#
&&  rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /var/lib/apt \
    /var/lib/dpkg/info \
    /var/log/apt \
    /var/log/journal \
    /var/log/xrdp* \
    /var/log/*.log \
    /tmp/* \
#
# Create unprivileged user
#
# &&  sed -i '/en_US.UTF/ s/^#//;s/^ *//' /etc/locale.gen \
# &&  update-locale --no-checks LANG="en_US.UTF-8" \
# &&  locale-gen "en_US.UTF-8" \
# &&  groupadd -g "${PGID}" "${USER}" \
# &&  useradd -m -s /bin/zsh -u "${PUID}" -g "${PGID}" -c "ali@mustakim.com" -G dialout -p '$6$4XUjCfv1D9MC4RRh$JvANIuUtqK5aDNbHJMU0eCrlxg9TNnUpy3sYoK.jeCea0wdyjOH09uQublejMbsE83CcXTCSWK.x/LxvgJ4Pv0' "${USER}" \
&&  usermod -m -s /bin/zsh -d "/home/${USER}" -c "ali@mustakim.com" -G dialout -p '$6$4XUjCfv1D9MC4RRh$JvANIuUtqK5aDNbHJMU0eCrlxg9TNnUpy3sYoK.jeCea0wdyjOH09uQublejMbsE83CcXTCSWK.x/LxvgJ4Pv0' "${USER}" \
&&  if [ -d "/etc/sudoers.d" ]; then echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${USER}"; fi \
&&  install -d -o "${PUID}" -g "${PGID}" -m 700 "/run/user/${PUID}" \
#
# Modify configuration files
#
&&  chown -R ali /etc/xrdp/ \
&&  dirname $( readlink -f /etc/xrdp/key.pem ) | xargs chmod o+x \
&&  readlink -f /etc/xrdp/key.pem | xargs chmod +r \
&&  sed -i 's|LogFile=|LogFile=/tmp/|; /=Xvnc/,/port/ s|port=-1|port=5900|' /etc/xrdp/xrdp.ini \
&&  sed -i 's|LogFile=|LogFile=/tmp/|; s|#EnableFuseMount|EnableFuseMount|; s|param=.xorgxrdp|param=/tmp/.xorgxrdp|; s|FuseMountName=|FuseMountName=/tmp/|; /SessionVariables/aCHANSRV_LOG_PATH=\/tmp' /etc/xrdp/sesman.ini \
&&  sed -i 's|ERRFILE=$HOME|ERRFILE=\/tmp|' /etc/X11/Xsession \
&&  mkdir -p '/run/sshd'
#
# &&  echo "[unix_http_server] \n\
# file=/run/supervisor.sock \n\
# \n\
# [inet_http_server] \n\
# port=:9001 \n\
# \n\
# [supervisord] \n\
# logfile=/dev/null \n\
# nodaemon=true \n\
# pidfile=/tmp/supervisord.pid \n\
# \n\
# [program:ttyd] \n\
# autorestart=true \n\
# command=/bin/su - ali -c '/usr/local/bin/ttyd -p 8081 /usr/bin/tmux -u new -A -s ttyd' \n\
# priority=100 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:sshd] \n\
# autorestart=true \n\
# command=/usr/sbin/sshd -D \n\
# priority=110 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:xvfb] \n\
# autorestart=true \n\
# command=/usr/bin/Xvfb -ac +extension GLX -noreset +render -screen 0 1194x834x24 \n\
# priority=120 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:x11vnc] \n\
# autorestart=true \n\
# command=/usr/bin/x11vnc -display :0 -forever -loop -ncache_cr -nopw -noxdamage -N -q -shared \n\
# priority=122 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:novnc] \n\
# autorestart=true \n\
# command=/bin/su - ali -c '/usr/share/novnc/utils/novnc_proxy' \n\
# priority=124 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:openbox] \n\
# autorestart=true \n\
# command=/bin/su - ali -c 'DISPLAY=:0 /usr/bin/openbox-session' \n\
# priority=126 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:xrdp-sesman] \n\
# autorestart=true \n\
# command=/usr/sbin/xrdp-sesman --nodaemon \n\
# priority=130 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n\
# [program:xrdp] \n\
# autorestart=true \n\
# command=/usr/sbin/xrdp --nodaemon \n\
# priority=132 \n\
# stderr_logfile=/dev/stderr \n\
# stderr_logfile_maxbytes=0 \n\
# stdout_logfile=/dev/stdout \n\
# stdout_logfile_maxbytes=0 \n\
# \n" > /etc/supervisor/conf.d/supervisord.conf
#
# ENTRYPOINT [ "supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]


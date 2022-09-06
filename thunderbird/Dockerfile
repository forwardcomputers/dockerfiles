#
#APPNEW 1.0
#
FROM debian:latest
#
ENV DISPLAY=:0
ENV DATA_DIR="/thunderbird"
ENV USER="thunderbird"
ENV UID=1999
ENV GID=1999
EXPOSE 6080
#
# Update repos and install packages
#
RUN apt-get update && apt-get -y full-upgrade && apt-get -y --no-install-recommends install \
    openbox \
    net-tools \
    novnc \
    procps \
    x11vnc \
    xvfb \
    thunderbird \
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
      /var/log/*.log \
      /tmp/* \
#
&&  groupadd -g "${GID}" "${USER}" \
&&  useradd -d "${DATA_DIR}" -m -s /bin/bash -u "${UID}" -g "${GID}" "${USER}"
#
USER "${USER}"
ENTRYPOINT \
    usermod -u "${UID}" "${USER}" ; \
    groupmod -g "${GID}" "${USER}" ; \
    usermod -g "${GID}" "${USER}" ; \
    ( /usr/bin/nohup /usr/bin/Xvfb :0 -screen 0 1024x768x24 & ) ; \
    ( /usr/bin/nohup /usr/bin/x11vnc & ) ; \
    ( /usr/bin/nohup /usr/share/novnc/utils/launch.sh & ) ; \
    /usr/bin/openbox --startup /usr/bin/thunderbird
#
# Use
# docker run --name thunderbird -d -p 6080:6080 -v /opt/filer/os/lnx/data/thunderbird:/thunderbird forwardcomputers/thunderbird
# http://virt:6080/vnc_lite.html
# http://virt:6080/vnc.html?autoconnect=true
#
#APPNEW 1.0
#
# Based on the work from https://github.com/mkuf/prind
# On python 3.11 due to greenlet
FROM python:3.11-bookworm AS build
#
## the build image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    avr-libc \
    avrdude \
    binutils-arm-none-eabi \
    binutils-avr \
    build-essential \
    cmake \
    dfu-util \
    gcc-arm-none-eabi \
    gcc-avr \
    git \
    libbsd-dev \
    libcurl4-openssl-dev \
    libffi-dev \
    libjpeg-dev \
    liblmdb-dev \
    libncurses-dev \
    libnewlib-arm-none-eabi \
    libsodium-dev \
    libssl-dev \
    libusb-1.0-0 \
    libusb-1.0-0-dev \
    pkg-config \
    python3-dev \
    python3-libgpiod \
    python3-numpy \
    python3-matplotlib \
    python3-virtualenv \
    stm32flash \
    swig \
    zlib1g-dev

WORKDIR /opt

#### klipper
COPY simulavr.config .config
RUN git clone https://github.com/klipper3d/klipper \
&&  python -m venv klippy-env \
&&  klippy-env/bin/pip install -r klipper/scripts/klippy-requirements.txt \
&&  klippy-env/bin/python -m compileall klipper/klippy \
&&  klippy-env/bin/python klipper/klippy/chelper/__init__.py \
    # build the firmware
&&  mv .config klipper/.config \
&&  make -C klipper PYTHON=python3 \
&&  mv klipper/out/klipper.elf ./simulavr.elf \
&&  rm -f klipper/.config*.* \
&&  make -C klipper PYTHON=python3 clean

#### moonraker
RUN git clone https://github.com/Arksine/moonraker \
&&  python -m venv moonraker-env \
&&  moonraker-env/bin/pip install -r moonraker/scripts/moonraker-requirements.txt

#### obico
RUN git clone https://github.com/TheSpaghettiDetective/moonraker-obico.git \
&&  python -m venv obico-env \
&&  obico-env/bin/pip install -r moonraker-obico/requirements.txt

#### ustreamer
RUN git clone https://github.com/pikvm/ustreamer \
&&  make -C ustreamer

#### mainsail
RUN curl -sLo /tmp/mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip \
&&  unzip /tmp/mainsail.zip -d mainsail

#### simulavr
RUN git clone -b master https://git.savannah.nongnu.org/git/simulavr.git \
&&  make -C simulavr cfgclean python build clean

## the final image
#
FROM python:3.11-slim AS final
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
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    curl \
    git \
    gnupg1 \
    iproute2 \
    janus \
    libcurl4 \
    libevent-2.1-7 \
    libevent-pthreads-2.1-7 \
    libjpeg62-turbo \
    liblmdb0 \
    libopenjp2-7 \
    libsodium23 \
    libssl3 \
    libtiff6 \
    libxcb1 \
    lsb-release \
    nginx \
    sudo \
    systemd \
    zlib1g \
    ### clean up
&&  apt-get -y autoremove \
&&  apt-get clean \
&&  rm -rf \
    /etc/nginx/sites-enabled/default \
    /tmp/* /var/tmp/* \
    /usr/local/share/man/* \
    /usr/share/doc/* \
    /usr/share/doc-base/* \
    /usr/share/vim \
    /usr/share/zsh \
    /var/lib/apt/lists/* \
    /var/cache/* \
    /var/log/* \
    /var/www \
# add user
&&  groupadd printer --force -g 1001 \
&&  useradd printer -rm -d /home/printer -g 1001 -u 1001 \
&&  usermod printer -aG dialout,tty,video \
&&  echo 'printer ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/printer \
# nginx
&&  sed -i 's@/var/log/nginx/access.log@/dev/stdout@g' /etc/nginx/nginx.conf \
&&  sed -i 's@/var/log/nginx/error.log@/dev/stderr@g' /etc/nginx/nginx.conf \
&&  touch /var/run/nginx.pid \
&&  chown -R printer:printer /etc/nginx/conf.d /var/lib/nginx /var/run/nginx.pid /usr/share/nginx

COPY --chmod=755 start.sh /bin/start

USER printer
WORKDIR /home/printer

RUN mkdir -p \
    printer_data \
&&  chown -R printer:printer /home/printer/*

# copy prebuilt applications from the build stage
COPY --from=build --chown=printer:printer /opt/klippy-env ./klippy-env
COPY --from=build --chown=printer:printer /opt/klipper/ ./klipper/
COPY --from=build --chown=printer:printer /opt/moonraker ./moonraker
COPY --from=build --chown=printer:printer /opt/moonraker-env ./moonraker-env
COPY --from=build --chown=printer:printer /opt/moonraker-obico ./moonraker-obico
COPY --from=build --chown=printer:printer /opt/obico-env ./obico-env
COPY --from=build --chown=printer:printer /opt/simulavr ./simulavr
COPY --from=build --chown=printer:printer /opt/simulavr.elf ./simulavr.elf
COPY --from=build --chown=printer:printer /opt/ustreamer ./ustreamer
COPY --from=build --chown=printer:printer /opt/mainsail ./mainsail

ENTRYPOINT ["/bin/start"]


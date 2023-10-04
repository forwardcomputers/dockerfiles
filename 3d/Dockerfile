## The build image
FROM python:3.11-bookworm AS build

RUN apt-get update && apt-get install -y \
    avr-libc \
    binutils-avr \
    build-essential \
    cmake \
    gcc-avr \
    libbsd-dev \
    # libcurl4-openssl-dev \
    # libssl-dev \
    python3-dev \
    # python3-libgpiod \
    swig \
    # virtualenv \
    ### clean up
&&  apt-get -y autoremove \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /opt

#### klipper
RUN git clone https://github.com/klipper3d/klipper \
&&  python -m venv klippy-env \
&&  klippy-env/bin/pip install -r klipper/scripts/klippy-requirements.txt \
# &&  klippy-env/bin/pip install numpy \
&&  klippy-env/bin/python -m compileall klipper/klippy \
&&  klippy-env/bin/python klipper/klippy/chelper/__init__.py

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

# #### mjpg-streamer
# RUN git clone --depth 1 https://github.com/jacksonliam/mjpg-streamer \
# &&  mkdir mjpg-streamer/mjpg-streamer-experimental/_build \
# &&  cd mjpg-streamer/mjpg-streamer-experimental/_build \
# &&  cmake -DPLUGIN_INPUT_HTTP=OFF -DPLUGIN_INPUT_UVC=OFF -DPLUGIN_OUTPUT_FILE=OFF -DPLUGIN_OUTPUT_RTSP=OFF -DPLUGIN_OUTPUT_UDP=OFF .. \
# &&  cd .. \
# &&  make \
# &&  cd /opt

#### Simulavr
    # Build the firmware
COPY simulavr.config klipper/.config
RUN make -C klipper PYTHON=python3 \
&&  mv klipper/out/klipper.elf ./simulavr.elf \
&&  rm -f klipper/.config*.* \
&&  make -C klipper PYTHON=python3 clean \
    # Build simulavr
&&  git clone -b master https://git.savannah.nongnu.org/git/simulavr.git \
&&  make -C simulavr cfgclean python build clean

## The final image

FROM python:3.11-slim AS final

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    --no-install-suggests \
    curl \
    ffmpeg \
    git \
    iproute2 \
    janus \
    # libcurl4 \
    libevent-2.1-7 \
    libevent-pthreads-2.1-7 \
    libjpeg62-turbo \
    # liblmdb0 \
    # libopenjp2-7 \
    libsodium23 \
    # libssl3 \
    # libtiff6 \
    # libxcb1 \
    # python3-libgpiod \
    sudo \
    systemd \
    # zlib1g \
    ### clean up
&&  apt-get -y autoremove \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY --chmod=755 start.sh /bin/start

RUN groupadd printer --force -g 1001 \
&&  useradd printer -rm -d /home/printer -g 1001 -u 1001 \
&&  usermod printer -aG dialout,tty,video \
&&  echo 'printer ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/printer

USER printer
WORKDIR /home/printer

RUN mkdir -p \
    printer_data \
&&  chown -R printer:printer /home/printer/*

# Copy prebuilt applications from the build stage
COPY --from=build --chown=printer:printer /opt/klippy-env ./klippy-env
COPY --from=build --chown=printer:printer /opt/klipper/ ./klipper/
COPY --from=build --chown=printer:printer /opt/moonraker ./moonraker
COPY --from=build --chown=printer:printer /opt/moonraker-env ./moonraker-env
COPY --from=build --chown=printer:printer /opt/moonraker-obico ./moonraker-obico
COPY --from=build --chown=printer:printer /opt/obico-env ./obico-env
COPY --from=build --chown=printer:printer /opt/simulavr ./simulavr
COPY --from=build --chown=printer:printer /opt/simulavr.elf ./simulavr.elf
# COPY --from=build --chown=printer:printer /opt/mjpg-streamer/mjpg-streamer-experimental ./mjpg-streamer
COPY --from=build --chown=printer:printer /opt/ustreamer ./ustreamer

ENTRYPOINT ["/bin/start"]
# ENTRYPOINT ["sleep", "infinity"]


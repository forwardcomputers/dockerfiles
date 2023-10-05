#!/bin/sh
#

# simulavr
export PYTHONPATH="/home/printer/simulavr/build/pysimulavr"
/home/printer/klippy-env/bin/python /home/printer/klipper/scripts/avrsim.py \
-p /home/printer/printer_data/run/simulavr.tty \
/home/printer/simulavr.elf &

# moonraker
/home/printer/moonraker-env/bin/python /home/printer/moonraker/moonraker/moonraker.py \
-d /home/printer/printer_data \
-l /home/printer/printer_data/logs/moonraker.log &

# obico
export PYTHONPATH="/home/printer/moonraker-obico"
/home/printer/obico-env/bin/python \
-m moonraker_obico.link \
-c /home/printer/printer_data/config/moonraker-obico.cfg &

# klipper
/home/printer/klippy-env/bin/python /home/printer/klipper/klippy/klippy.py \
-a /home/printer/printer_data/run/klipper.sock \
-I /home/printer/printer_data/run/klipper.tty \
-l /home/printer/printer_data/logs/klipper.log \
/home/printer/printer_data/config/printer-simulavr.cfg &

# ustreamer
/home/printer/ustreamer/ustreamer \
--host=0.0.0.0 \
--port=8080 \
--slowdown \
--device=/dev/webcam \
--resolution=1280x720 \
--format=MJPEG \
--desired-fps=30 &

# nginx
nginx -g 'daemon off;'

# sleep infinity

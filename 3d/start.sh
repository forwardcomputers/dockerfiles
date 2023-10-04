#!/bin/sh
#

# simulavr
export PYTHONPATH="/home/printer/simulavr/build/pysimulavr"
nohup /home/printer/klippy-env/bin/python /home/printer/klipper/scripts/avrsim.py \
-p /home/printer/printer_data/run/simulavr.tty \
/home/printer/simulavr.elf &

# moonraker
nohup /home/printer/moonraker-env/bin/python /home/printer/moonraker/moonraker/moonraker.py \
-d /home/printer/printer_data \
-l /home/printer/printer_data/logs/moonraker.log &

# obico
export PYTHONPATH="/home/printer/moonraker-obico"
nohup /home/printer/obico-env/bin/python \
-m moonraker_obico.link \
-c /home/printer/printer_data/config/moonraker-obico.cfg &

# klipper
nohup /home/printer/klippy-env/bin/python /home/printer/klipper/klippy/klippy.py \
-a /home/printer/printer_data/run/klipper.sock \
-I /home/printer/printer_data/run/klipper.tty \
-l /home/printer/printer_data/logs/klipper.log \
/home/printer/printer_data/config/printer-simulavr.cfg &

# ustreamer
nohup /home/printer/ustreamer/ustreamer \
--host=0.0.0.0 \
--port=8080 \
--slowdown \
--device=/dev/webcam \
--resolution=1280x720 \
--format=MJPEG \
--desired-fps=30 &

# # streamer
# export LD_LIBRARY_PATH="/home/printer/mjpg-streamer"
# cp -R /home/printer/example-configs/images/*.jpg /home/printer/printer_data/webcam_images
# nohup /home/printer/mjpg-streamer/mjpg_streamer \
# -i "/home/printer/mjpg-streamer/input_file.so -e -d 0.8 -f /home/printer/printer_data/webcam_images" \
# -o "/home/printer/mjpg-streamer/output_http.so -w /home/printer/mjpg-streamer/www" &

sleep infinity

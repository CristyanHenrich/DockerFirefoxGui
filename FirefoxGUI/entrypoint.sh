#!/bin/bash

Xvfb :99 -ac -screen 0 1280x1024x24 &

sleep 1

x11vnc -display :99 -forever -nopw -rfbport 5900 &

export DISPLAY=:99

exec "$@"
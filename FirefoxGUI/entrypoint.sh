#!/bin/bash

# Clean up stale locks for Xvfb and X11
rm -f /tmp/.X99-lock
rm -rf /tmp/.X11-unix/X99

# Start Xvfb
Xvfb :99 -ac -screen 0 1280x1024x24 &

# Wait for Xvfb
sleep 2

# Start x11vnc
x11vnc -display :99 -forever -nopw -rfbport 5900 &

export DISPLAY=:99

# Start the command (Firefox)
exec "$@"
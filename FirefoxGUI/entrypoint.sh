#!/bin/bash

# Clean up stale locks for Xvfb and X11
rm -f /tmp/.X99-lock
rm -rf /tmp/.X11-unix/X99

# Start DBUS (necessary for XFCE and modern apps)
export $(dbus-launch)

# Start Xvfb (Virtual Framebuffer)
Xvfb :99 -ac -screen 0 1920x1080x24 &

# Wait for Xvfb to be ready
sleep 2

# Start x11vnc (VNC Server)
x11vnc -display :99 -forever -nopw -rfbport 5900 &

export DISPLAY=:99

# Execute the CMD (startxfce4)
exec "$@"
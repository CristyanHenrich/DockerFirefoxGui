#!/bin/bash

# Clean up stale locks for Xvfb and X11
rm -f /tmp/.X99-lock
rm -rf /tmp/.X11-unix/X99

# Configure proxychains4 if proxy environment variables are set
if [ -n "$PROXY_USERNAME" ]; then
    cat <<EOF > /etc/proxychains4.conf
strict_chain
proxy_dns 
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
http $DOMAIN_NAME $PROXY_PORT $PROXY_USERNAME $PROXY_PASSWORD
EOF
    echo "Proxychains configured for $DOMAIN_NAME:$PROXY_PORT"
fi

# Start Xvfb
Xvfb :99 -ac -screen 0 1280x1024x24 &

# Wait for Xvfb
sleep 2

# Start x11vnc
x11vnc -display :99 -forever -nopw -rfbport 5900 &

export DISPLAY=:99

# If proxy is configured, prepend proxychains4 to the command
if [ -n "$PROXY_USERNAME" ]; then
    echo "Starting with proxychains4..."
    exec proxychains4 "$@"
else
    exec "$@"
fi
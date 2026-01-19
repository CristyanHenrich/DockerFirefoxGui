#!/bin/bash

# Clean up stale locks for Xvfb and X11
rm -f /tmp/.X99-lock
rm -rf /tmp/.X11-unix/X99

# Configure proxychains4 if proxy environment variables are set
if [ -n "$PROXY_USERNAME" ]; then
    echo "Resolving proxy hostname: $DOMAIN_NAME..."
    # Resolve IP address because proxychains4 requires the first proxy to be an IP
    PROXY_IP=$(getent hosts "$DOMAIN_NAME" | awk '{ print $1 }' | head -n 1)
    
    if [ -z "$PROXY_IP" ]; then
        echo "Warning: Could not resolve $DOMAIN_NAME, using hostname directly (may fail)."
        PROXY_IP=$DOMAIN_NAME
    else
        echo "Resolved $DOMAIN_NAME to $PROXY_IP"
    fi

    cat <<EOF > /etc/proxychains4.conf
strict_chain
proxy_dns 
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
http $PROXY_IP $PROXY_PORT $PROXY_USERNAME $PROXY_PASSWORD
EOF
    echo "Proxychains configured for $PROXY_IP:$PROXY_PORT"
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
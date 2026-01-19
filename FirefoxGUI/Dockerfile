FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    libgl1-mesa-dri \
    software-properties-common \
    ca-certificates \
    dbus-x11 \
    xfce4 \
    xfce4-terminal \
    xfce4-screenshooter \
    mousepad \
    && add-apt-repository -y ppa:mozillateam/ppa \
    && echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozilla \
    && apt-get update && apt-get install -y firefox \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["startxfce4"]
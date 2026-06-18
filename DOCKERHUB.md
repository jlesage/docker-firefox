# Docker container for Firefox
[![Release](https://img.shields.io/github/release/jneisener/docker-firefox.svg?logo=github&style=for-the-badge)](https://github.com/jneisener/docker-firefox/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jneisener/firefox/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jneisener/firefox/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jneisener/firefox?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jneisener/firefox)
[![Docker Stars](https://img.shields.io/docker/stars/jneisener/firefox?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jneisener/firefox)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jneisener/docker-firefox/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jneisener/docker-firefox/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jneisener/docker-firefox)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This project provides a lightweight and secure Docker container for
[Firefox](https://www.mozilla.org/firefox/).

Access the application's full graphical interface directly from any modern web
browser - no downloads, installs, or setup required on the client side - or
connect with any VNC client.

The web interface also offers audio playback, seamless clipboard sharing, an
integrated file manager and terminal for accessing the container's files and
shell, desktop notifications, and more.

> This Docker container is entirely unofficial and not made by the creators of
> Firefox.

---

[![Firefox logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jneisener/docker-templates/master/jlesage/images/firefox-icon.png&w=110)](https://www.mozilla.org/firefox/)[![Firefox](https://images.placeholders.dev/?width=224&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Firefox&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.mozilla.org/firefox/)

Mozilla Firefox is a free and open-source web browser developed by Mozilla
Foundation and its subsidiary, Mozilla Corporation.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is an example, and parameters
    should be adjusted to suit your needs.

Launch the Firefox docker container with the following command:
```shell
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jneisener/firefox
```

Where:

  - `/docker/appdata/firefox`: Stores the application's configuration, state, logs, and any files requiring persistency.

Access the Firefox GUI by browsing to `http://your-host-ip:5800`.

## Documentation

Full documentation is available at https://github.com/jneisener/docker-firefox.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jneisener/docker-firefox/issues).

For other Dockerized applications, visit https://jneisener.github.io/docker-apps.

# Docker container for Firefox
[![Release](https://img.shields.io/github/release/jlesage/docker-firefox.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-firefox/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/firefox/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/firefox?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/firefox?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-firefox/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-firefox/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-firefox)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Firefox](https://www.mozilla.org/firefox/).

The graphical user interface (GUI) of the application can be accessed through a
modern web browser, requiring no installation or configuration on the client

---

[![Firefox logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/firefox-icon.png&w=110)](https://www.mozilla.org/firefox/)[![Firefox](https://images.placeholders.dev/?width=224&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Firefox&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.mozilla.org/firefox/)

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
    jlesage/firefox
```

Where:

  - `/docker/appdata/firefox`: Stores the application's configuration, state, logs, and any files requiring persistency.

Access the Firefox GUI by browsing to `http://your-host-ip:5800`.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-firefox.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jlesage/docker-firefox/issues).

For other Dockerized applications, visit https://jlesage.github.io/docker-apps.

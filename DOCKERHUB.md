# Docker container for Firefox
[![Release](https://img.shields.io/github/release/jlesage/docker-firefox.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-firefox/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/firefox/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/firefox?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/firefox?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/firefox)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-firefox/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-firefox/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-firefox)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Firefox](https://www.mozilla.org/en-US/firefox/).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![Firefox logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/firefox-icon.png&w=110)](https://www.mozilla.org/en-US/firefox/)[![Firefox](https://images.placeholders.dev/?width=224&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Firefox&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.mozilla.org/en-US/firefox/)

Mozilla Firefox is a free and open-source web browser developed by Mozilla
Foundation and its subsidiary, Mozilla Corporation.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the Firefox docker container with the following command:
```shell
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jlesage/firefox
```

Where:
  - `/docker/appdata/firefox`: This is where the application stores its configuration, states, log and any files needing persistency.

Browse to `http://your-host-ip:5800` to access the Firefox GUI.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-firefox.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-firefox/issues

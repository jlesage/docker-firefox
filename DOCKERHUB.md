# Docker container for Firefox
[![Docker Image Size](https://img.shields.io/microbadger/image-size/jlesage/firefox)](http://microbadger.com/#/images/jlesage/firefox) [![Build Status](https://drone.le-sage.com/api/badges/jlesage/docker-firefox/status.svg)](https://drone.le-sage.com/jlesage/docker-firefox) [![GitHub Release](https://img.shields.io/github/release/jlesage/docker-firefox.svg)](https://github.com/jlesage/docker-firefox/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/JocelynLeSage/0usd)

This is a Docker container for [Firefox](https://www.mozilla.org/en-US/firefox/).

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

[![Firefox logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/firefox-icon.png&w=200)](https://www.mozilla.org/en-US/firefox/)[![Firefox](https://dummyimage.com/400x110/ffffff/575757&text=Firefox)](https://www.mozilla.org/en-US/firefox/)

Mozilla Firefox is a free and open-source web browser developed by Mozilla Foundation and its subsidiary, Mozilla Corporation.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the Firefox docker container with the following command:
```
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    --shm-size 2g \
    jlesage/firefox
```

Where:
  - `/docker/appdata/firefox`: This is where the application stores its configuration, log and any files needing persistency.

Browse to `http://your-host-ip:5800` to access the Firefox GUI.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-firefox.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-firefox/issues

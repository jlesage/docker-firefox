# Docker container for Camoufox + Playwright

This repository publishes a GUI-enabled Camoufox browser packaged with the Playwright runtime.
Camoufox binaries are downloaded on first start and combined with the `jlesage/baseimage-gui` stack so you can
interact with the browser over noVNC or drive it remotely via Playwright.

## Quick start

```
docker run -d \
  --name=camoufox \
  -p 5800:5800 \
  -v /docker/appdata/camoufox:/config:rw \
  ghcr.io/batrapvd/docker-camoufox-playwright:latest
```

Camoufox stores its profile and Playwright artifacts inside `/config`. Open `http://<host-ip>:5800` to reach the noVNC UI.

## Documentation

See the full documentation at https://github.com/batrapvd/docker-camoufox-playwright.

## Support

Questions or issues? [Open an issue](https://github.com/batrapvd/docker-camoufox-playwright/issues).

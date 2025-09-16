# Docker container for Camoufox + Playwright

This project packages [Camoufox](https://camoufox.com) inside a headless-friendly GUI container.
It replaces the stock Firefox build with Camoufox's fingerprint-resistant binaries while keeping the familiar
remote desktop experience provided by [jlesage/baseimage-gui](https://github.com/jlesage/baseimage-gui).
Playwright is pre-installed and configured so you can either control the browser interactively via the built-in VNC
interface or automate it using Playwright's WebSocket server.

## Features

- ✅ Ships with the latest Camoufox browser (downloaded on first start for the running architecture).
- ✅ Playwright Python runtime and drivers are pre-installed.
- ✅ Works on x86_64 and arm64 VPS hosts – the container fetches the matching Camoufox build at runtime.
- ✅ Web UI available over noVNC or VNC clients; persistent profile stored under `/config/profile`.
- ✅ Optional Playwright server mode for remote automation clients.

## Quick start

```
docker run -d \
  --name=camoufox \
  -p 5800:5800 \
  -v /docker/appdata/camoufox:/config:rw \
  ghcr.io/batrapvd/docker-camoufox-playwright:latest
```

Where:

- `/docker/appdata/camoufox` stores Camoufox's profile, Playwright downloads, logs and settings.
- Port `5800` exposes the HTML5 noVNC interface. Expose port `5900` if you prefer connecting with a VNC client.

Access the UI at `http://<host-ip>:5800` once the container is running.

## Usage

You can configure the container via environment variables. Existing Firefox variables are still supported for backward
compatibility, while new `CAMOUFOX_*` flags expose Camoufox-specific behaviour.

### General settings

| Variable | Description | Default |
| --- | --- | --- |
| `FF_OPEN_URL` | Pipe-separated list of URLs opened when Camoufox starts. | _(none)_ |
| `FF_KIOSK` | Set to `1` to enable kiosk mode (full screen, no chrome). | `0` |
| `FF_CUSTOM_ARGS` | Extra command-line flags passed to Camoufox. | _(none)_ |
| `KEEP_APP_RUNNING` | Restart the browser automatically if it exits unexpectedly. | `0` |
| `DISPLAY_WIDTH` / `DISPLAY_HEIGHT` | Virtual display resolution exposed over VNC/noVNC. | `1920` / `1080` |

### Camoufox / Playwright options

| Variable | Description | Example |
| --- | --- | --- |
| `CAMOUFOX_SERVER` | Set to `1` to start the Playwright server instead of the interactive browser. The server prints the WebSocket endpoint on startup. | `1` |
| `PLAYWRIGHT_SERVER` | Legacy alias for `CAMOUFOX_SERVER`. | `1` |
| `CAMOUFOX_HEADLESS` | Set to `true`, `false`, or `virtual` to control headless mode. `virtual` keeps rendering via an Xvfb display. | `virtual` |
| `CAMOUFOX_CONFIG_JSON` | Inline JSON with Camoufox fingerprint overrides. | `'{"navigator":{"platform":"Win32"}}'` |
| `CAMOUFOX_CONFIG_FILE` | Path inside the container to a JSON config file consumed by Camoufox. | `/config/camoufox.json` |
| `CAMOUFOX_OS` | Comma-separated list of OS targets used for fingerprint generation. | `windows,macos` |
| `CAMOUFOX_BLOCK_IMAGES` | Block image requests at the network level (`true`/`false`). | `true` |
| `CAMOUFOX_BLOCK_WEBRTC` | Disable WebRTC to avoid IP leaks. | `true` |
| `CAMOUFOX_BLOCK_WEBGL` | Disable WebGL rendering. | `true` |
| `CAMOUFOX_DISABLE_COOP` | Disable Cross-Origin Opener Policy protections (useful for some automation cases). | `true` |
| `CAMOUFOX_ENABLE_CACHE` | Explicitly enable or disable the browser cache. | `false` |
| `CAMOUFOX_LOCALE` | Override locale selection; accepts single value or comma-separated list. | `en-US` |
| `CAMOUFOX_HUMANIZE` | Enable human-like cursor movement. Accepts `true/false` or a float representing max move time. | `1.2` |
| `CAMOUFOX_WINDOW` | Override initial window size, using `WIDTHxHEIGHT` or `WIDTH,HEIGHT`. | `1280x720` |
| `CAMOUFOX_PROXY` | Proxy URL passed to Playwright (`scheme://user:pass@host:port`). | `http://proxy.example:8080` |
| `CAMOUFOX_DEBUG` | Emit verbose Camoufox debug information. | `1` |

### Optional GeoIP data

Install the package with `camoufox[geoip]` to allow Camoufox to derive location-aware fingerprints. You can extend the image
or run the following inside the container:

```
python3 -m pip install --no-cache-dir 'camoufox[geoip]'
python3 -m camoufox fetch --browserforge
```

## Playwright server mode

Set `CAMOUFOX_SERVER=1` (or `PLAYWRIGHT_SERVER=1`) to start a long-running Playwright server. The container will log a line similar to:

```
Websocket endpoint: ws://127.0.0.1:59545/xxxxxxxx
```

You can connect from a client machine using Playwright for Python:

```python
from playwright.sync_api import sync_playwright

ws_endpoint = "ws://<host-ip>:59545/xxxxxxxx"
with sync_playwright() as p:
    browser = p.firefox.connect(ws_endpoint)
    page = browser.new_page()
    page.goto("https://example.com")
```

The server inherits the same launch options described above, so you can combine `CAMOUFOX_*` variables with automation.

## Persistent profile & data

The startup wrapper preserves Camoufox data under `/config/profile`. Passing `FF_CUSTOM_ARGS` or the default
parameter helper located at `/etc/services.d/app/params` allows you to extend the command line with additional Firefox-compatible
flags (for example `--private-window`).

Playwright browser binaries are downloaded under `/config/playwright` so that subsequent container restarts do not re-fetch assets.

## Running on ARM VPS hosts

Both `jlesage/baseimage-gui` and Camoufox publish multi-architecture builds. When the container starts, `camoufox fetch`
detects the runtime architecture (`x86_64`, `arm64`, `i686`) and downloads the matching bundle. Ensure outbound HTTPS access
to `github.com` so the download can succeed the first time.

## Troubleshooting

- **membarrier system call**: Camoufox inherits Firefox's requirement for the `membarrier` syscall. If you are running Docker `< 20.10`, either
  supply a custom seccomp profile that allows `membarrier`, run with `--security-opt seccomp=unconfined`, or enable privileged mode.
- **First start takes time**: the initial `camoufox fetch` download is several hundred megabytes. Future starts reuse the cached binaries.
- **Addon downloads blocked**: Camoufox attempts to download default extensions such as uBlock Origin. If your environment blocks
  direct access to `addons.mozilla.org`, set `CAMOUFOX_DISABLE_DEFAULT_ADDONS=1` in a custom image or provide your own add-ons via `CAMOUFOX_CONFIG_JSON`.
- **Playwright connection refused**: when using server mode behind NAT, map the dynamic WebSocket port (`--network host` or `-p <hostPort>:<containerPort>`) or
  configure a reverse proxy.

## Support

Report issues and improvements on the GitHub issue tracker for this repository.

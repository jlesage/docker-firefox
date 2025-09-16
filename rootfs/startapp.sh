#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export HOME=/config
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export PLAYWRIGHT_BROWSERS_PATH=${PLAYWRIGHT_BROWSERS_PATH:-/config/playwright}

PIDS=

notify() {
    for N in $(ls /etc/logmonitor/targets.d/*/send)
    do
       "$N" "$1" "$2" "$3" &
       PIDS="$PIDS $!"
    done
}

# Verify support for membarrier.
if ! /usr/bin/membarrier_check 2>/dev/null; then
   notify "$APP_NAME requires the membarrier system call." "$APP_NAME is likely to crash because it requires the membarrier system call.  See the documentation of this Docker container to find out how this system call can be allowed." "WARNING"
fi

# Wait for all PIDs to terminate.
set +e
for PID in "$PIDS"; do
   wait $PID
done
set -e

# Ensure required directories exist.
mkdir -p "$PLAYWRIGHT_BROWSERS_PATH"
mkdir -p /config/log/camoufox

# Make sure Camoufox binaries are available for the current architecture.
CF_PATH="$(python3 -m camoufox path 2>/dev/null || true)"
if [ ! -d "$CF_PATH" ] || [ -z "$(ls -A "$CF_PATH" 2>/dev/null)" ]; then
    if ! python3 -m camoufox fetch; then
        notify "Unable to install Camoufox." "Downloading Camoufox binaries failed. Check your network access and restart the container." "ERROR"
        exit 1
    fi
fi

python3 -m camoufox version || true
exec /usr/local/bin/camoufox-launcher "$@" >> /config/log/camoufox/output.log 2>> /config/log/camoufox/error.log

# vim:ft=sh:ts=4:sw=4:et:sts=4

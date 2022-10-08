#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export HOME=/config

/usr/bin/firefox --version
exec /usr/bin/firefox "$@" >> /config/log/firefox/output.log 2>> /config/log/firefox/error.log

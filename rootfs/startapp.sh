#!/bin/sh
export HOME=/config
mkdir -p /config/profile
exec /usr/bin/firefox --profile /config/profile --setDefaultBrowser >> /config/log/firefox/output.log 2>> /config/log/firefox/error.log

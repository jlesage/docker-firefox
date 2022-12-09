#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure some directories are created.
mkdir -p /config/downloads
mkdir -p /config/log/firefox
mkdir -p /config/profile

# Generate machine id.
if [ ! -f /config/machine-id ]; then
    echo "generating machine-id..."
    cat /proc/sys/kernel/random/uuid | tr -d '-' > /config/machine-id
fi

# Copy default preferences.
[ -f /config/profile/prefs.js ] || cp /defaults/prefs.js /config/profile/prefs.js

# Verify the size of /dev/shm.
SHM_SIZE_MB="$(df -m /dev/shm | tail -n 1 | tr -s ' ' | cut -d ' ' -f2)"
if [ "$SHM_SIZE_MB" -eq 64 ]; then
   echo 'SHM_CHECK_FAIL' > /tmp/.firefox_shm_check
else
   echo 'SHM_CHECK_PASS' > /tmp/.firefox_shm_check
fi
chown $USER_ID:$GROUP_ID /tmp/.firefox_shm_check

if /usr/bin/membarrier_check 2>/dev/null; then
   echo 'MEMBARRIER_CHECK_PASS' > /tmp/.firefox_membarrier_check
else
   echo 'MEMBARRIER_CHECK_FAIL' > /tmp/.firefox_membarrier_check
fi
chown $USER_ID:$GROUP_ID /tmp/.firefox_membarrier_check

# Clean/optimize Firefox databases.
#if [ -d /config/.mozilla/firefox ] && [ -d /config/profile ]; then
#    [ -f /config/.mozilla/firefox/profiles.ini ] || cp /defaults/profiles.ini /config/.mozilla/firefox/
#    env HOME=/config /usr/bin/profile-cleaner f
#fi

# Fix window display size is session stores.
if [ -n "$(ls /config/profile/sessionstore-backups/*.jsonlz4 2>/dev/null)" ]; then
    for FILE in /config/profile/sessionstore-backups/*.jsonlz4; do
        WORKDIR="$(mktemp -d)"

        dejsonlz4 "$FILE" "$WORKDIR"/json
        cp "$WORKDIR"/json "$WORKDIR"/json.orig

        sed -i 's/"width":[0-9]\+/"width":'$DISPLAY_WIDTH'/' "$WORKDIR"/json
        sed -i 's/"height":[0-9]\+/"height":'$DISPLAY_HEIGHT'/' "$WORKDIR"/json
        sed -i 's/"screenX":[0-9]\+/"screenX":0/' "$WORKDIR"/json
        sed -i 's/"screenY":[0-9]\+/"screenY":0/' "$WORKDIR"/json

        if ! diff "$WORKDIR"/json "$WORKDIR"/json.orig >/dev/null; then
            jsonlz4 "$WORKDIR"/json "$WORKDIR"/jsonlz4
            mv "$WORKDIR"/jsonlz4 "$FILE"
            echo "fixed display size in $FILE."
        fi

        rm -r "$WORKDIR"
    done
fi

# Initialize log files.
for LOG_FILE in /config/log/firefox/output.log /config/log/firefox/error.log
do
    touch "$LOG_FILE"

    # Make sure the file doesn't grow indefinitely.
    if [ "$(stat -c %s "$LOG_FILE")" -gt 1048576 ]; then
       echo > "$LOG_FILE"
    fi
done

# vim: set ft=sh :

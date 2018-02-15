#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

log() {
    echo "[cont-init.d] $(basename $0): $*"
}

# Make sure some directories are created.
mkdir -p /config/downloads
mkdir -p /config/log/firefox

# Generate machine id.
log "generating machine-id..."
cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id

# Verify the size of /dev/shm.
SHM_SIZE_MB="$(df -m /dev/shm | tail -n 1 | tr -s ' ' | cut -d ' ' -f2)"
if [ "$SHM_SIZE_MB" -eq 64 ]; then
   echo 'FAIL' > /tmp/.firefox_shm_check
else
   echo 'PASS' > /tmp/.firefox_shm_check
fi

# Clean/optimize Firefox databases.
#if [ -d /config/.mozilla/firefox ] && [ -d /config/profile ]; then
#    [ -f /config/.mozilla/firefox/profiles.ini ] || cp /defaults/profiles.ini /config/.mozilla/firefox/
#    env HOME=/config /usr/bin/profile-cleaner f
#fi

# Make sure monitored log files exist.
for LOG_FILE in /config/log/firefox/error.log
do
    touch "$LOG_FILE"
done

# Take ownership of the config directory content.
chown -R $USER_ID:$GROUP_ID /config/*

# vim: set ft=sh :

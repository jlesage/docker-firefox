#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

log() {
    echo "[cont-init.d] $(basename $0): $*"
}

SND_DEV="/dev/snd"

if [ ! -d "$SND_DEV" ]; then
    log "sound not supported: device $SND_DEV not exposed to the container."
    exit 0
fi

# Save the associated group.
SND_GRP="$(find "$SND_DEV" -maxdepth 1 -not -type d -exec stat -c "%g" {} \; | sort -u | tail -n1)"
log "sound device group $SND_GRP."
if [ -f /var/run/s6/container_environment/SUP_GROUP_IDS ]; then
    echo -n "," >> /var/run/s6/container_environment/SUP_GROUP_IDS
fi
echo -n "$SND_GRP" >> /var/run/s6/container_environment/SUP_GROUP_IDS

# vim: set ft=sh :

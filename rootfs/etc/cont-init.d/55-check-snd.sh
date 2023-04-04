#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

SND_DEV="/dev/snd"

if [ ! -d "$SND_DEV" ]; then
    echo "sound not supported: device $SND_DEV not exposed to the container."
    exit 0
fi

# Save the associated group.
SND_GRP="$(find "$SND_DEV" -maxdepth 1 -not -type d -exec stat -c "%g" {} \; | sort -u | tail -n1)"
echo "sound device group $SND_GRP."

# vim:ft=sh:ts=4:sw=4:et:sts=4

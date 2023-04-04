#!/bin/sh

set -e

PREF_FILE="${1:-/config/profile/prefs.js}"

if [ -z "$PREF_FILE" ]; then
    echo "ERROR: Preference file not set."
    exit 1
fi

mkdir -p "$(dirname "$PREF_FILE")"
[ -f "$PREF_FILE" ] || touch "$PREF_FILE"

env | grep "^FF_PREF_" | while read ENV
do
    ENAME="$(echo "$ENV" | cut -d '=' -f1)"
    EVAL="$(echo "$ENV" | cut -d '=' -f2-)"

    if [ -z "$EVAL" ]; then
        echo "Skipping environment variable '$ENAME': no value set."
        continue
    fi

    if echo "$EVAL" | grep -q "="; then
        PNAME="$(echo "$EVAL" | cut -d '=' -f1)"
        PVAL="$(echo "$EVAL" | cut -d '=' -f2-)"
        [ -n "$PVAL" ] || PVAL='""'
    else
        PNAME="$EVAL"
        PVAL='""'
    fi 

    if [ "$PVAL" = "UNSET" ]; then
        echo "Removing preference '$PNAME'..."
        sed -i "/user_pref(\"$PNAME\",.*);/d" "$PREF_FILE"
    elif grep -q "user_pref(\"$PNAME\"," "$PREF_FILE"; then
        echo "Setting preference '$PNAME'..."
        sed -i "s/user_pref(\"$PNAME\",.*);/user_pref(\"$PNAME\", $PVAL);/" "$PREF_FILE"
    else
        echo "Setting new preference '$PNAME'..."
        echo "user_pref(\"$PNAME\", $PVAL);" >> "$PREF_FILE"
    fi
done

# vim:ft=sh:ts=4:sw=4:et:sts=4

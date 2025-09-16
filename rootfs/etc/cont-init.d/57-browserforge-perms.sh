#!/bin/sh

set -e

# Ensure the Browserforge package directory is writable by the runtime user so
# it can download its model zip files on first start.
PY_PURELIB=$(python3 - <<'PY'
import sysconfig
print(sysconfig.get_path('purelib'))
PY
)

if [ -n "$PY_PURELIB" ] && [ -d "$PY_PURELIB/browserforge" ]; then
    chmod -R a+rwX "$PY_PURELIB/browserforge" || true
fi

# vim:ft=sh:ts=4:sw=4:et:sts=4


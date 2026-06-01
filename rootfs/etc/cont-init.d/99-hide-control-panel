#!/bin/sh
# Hide the left-side three-dot control panel in the web UI

INDEX="/usr/local/lib/novnc/index.html"
if [ -f "$INDEX" ] && ! grep -q "control-panel-hidden" "$INDEX"; then
    sed -i 's|</head>|<style>#noVNC_control_panel, .noVNC_control_panel, [class*="control-panel"] { display: none !important; }</style>\n</head>|' "$INDEX"
    echo "Control panel hidden."
fi

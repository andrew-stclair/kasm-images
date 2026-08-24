#!/usr/bin/env bash
# Turns the desktop into a single-purpose kiosk that shows only the AWS
# WorkSpaces web client - no panel, no desktop icons, no browser chrome.
set -x

export DISPLAY=${DISPLAY:-:1}

# Wait for the X server to be ready before touching the desktop session.
for i in $(seq 1 60); do
    xset q >/dev/null 2>&1 && break
    sleep 1
done

# Give XFCE a moment to finish starting, then strip it down to bare desktop.
sleep 3
pkill -f xfce4-panel >/dev/null 2>&1
pkill -f xfdesktop >/dev/null 2>&1

# Launch the browser full screen with no address bar/tabs/menus, restarting
# it automatically if it ever exits.
while true; do
    google-chrome-stable \
        --no-sandbox \
        --kiosk \
        --no-first-run \
        --noerrdialogs \
        --disable-infobars \
        --disable-translate \
        --disable-session-crashed-bubble \
        --overscroll-history-navigation=0 \
        --start-fullscreen \
        --window-position=0,0 \
        "${AWS_WORKSPACES_URL}"
    sleep 2
done

#!/usr/bin/env bash
# Mirrors kasmweb/chrome's own startup loop, but launches in --kiosk mode
# locked to a single URL instead of a normal maximized browser window.
set -ex

START_COMMAND="google-chrome-stable"
PGREP="chrome"
# password-store=basic avoids Chrome prompting to unlock/create an OS keyring
ARGS="--kiosk --start-fullscreen --window-position=0,0 --no-first-run --noerrdialogs --disable-infobars --disable-translate --disable-session-crashed-bubble --overscroll-history-navigation=0 --password-store=basic --no-sandbox"
URL="${AWS_WORKSPACES_URL}"

echo "Entering process startup loop"
set +x
while true
do
    if ! pgrep -x $PGREP > /dev/null
    then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready
        set +e
        $START_COMMAND $ARGS "$URL"
        set -e
    fi
    sleep 1
done

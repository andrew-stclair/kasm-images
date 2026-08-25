#!/usr/bin/env bash
# Single-app startup script (see Kasm docs: Single App Workspace) that launches
# Chrome in --kiosk mode locked to a single URL instead of a normal desktop.
set -ex

START_COMMAND="google-chrome-stable"
PGREP="chrome"
# password-store=basic avoids Chrome prompting to unlock/create an OS keyring
DEFAULT_ARGS="--kiosk --start-fullscreen --window-position=0,0 --no-first-run --noerrdialogs --disable-infobars --disable-translate --disable-session-crashed-bubble --overscroll-history-navigation=0 --password-store=basic --no-sandbox"
ARGS=${APP_ARGS:-$DEFAULT_ARGS}
CHROME_PROFILE_DIR="$HOME/.config/google-chrome"

options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit
eval set -- "$options"
while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        -u|--url) OPT_URL=$2; shift 2;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

# On a persistent profile, Chrome leaves behind Singleton* files pointing at
# the previous session's hostname/pid. Since those no longer match on
# subsequent container launches, Chrome thinks another instance already owns
# the profile and refuses to open a window, so clear them before starting.
clear_singleton_locks() {
    rm -f "$CHROME_PROFILE_DIR/SingletonLock" \
          "$CHROME_PROFILE_DIR/SingletonSocket" \
          "$CHROME_PROFILE_DIR/SingletonCookie"
}

kasm_exec() {
    if [ -n "$OPT_URL" ] ; then
        URL=$OPT_URL
    elif [ -n "$1" ] ; then
        URL=$1
    fi
    if [ -n "$URL" ] ; then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready
        clear_singleton_locks
        $START_COMMAND $ARGS $URL
    else
        echo "No URL specified for exec command. Doing nothing."
    fi
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=${AWS_WORKSPACES_URL}
    fi
    echo "Entering process startup loop"
    set +x
    while true
    do
        if ! pgrep -x $PGREP > /dev/null
        then
            /usr/bin/filter_ready
            /usr/bin/desktop_ready
            clear_singleton_locks
            set +e
            $START_COMMAND $ARGS "$URL" &
            set -e
        fi
        sleep 1
    done
    set -x
}

if [ -n "$GO" ] || [ -n "$ASSIGN" ] ; then
    kasm_exec
else
    kasm_startup
fi

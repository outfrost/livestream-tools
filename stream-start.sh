#!/bin/sh

TWITCH_CHANNEL=outfr0st

if [ -z "$BOT_COMMAND" ]; then
	if [ -z "$BOT_DESKTOP_FILE" ]; then
		BOT_DESKTOP_FILE="$HOME/.local/share/applications/PhantomBot.desktop"
	fi
	BOT_COMMAND="kstart5 --service \'$BOT_DESKTOP_FILE\'"
fi

if [ -z "$LOG_DIR" ]; then
	LOG_DIR='/tmp/livestream-tools/log'
fi

mkdir -p "$LOG_DIR"

$BOT_COMMAND \
	> "$LOG_DIR/start-phantombot.log" 2>&1
google-chrome \
	--app='https://streamlabs.com/dashboard/recent-events' \
	> "$LOG_DIR/streamlabs.log" 2>&1
google-chrome \
	--app="https://twitch.tv/popout/$TWITCH_CHANNEL/chat" \
	> "$LOG_DIR/twitch-chat.log" 2>&1
google-chrome \
	--app='https://beta.nightbot.tv/dashboard' \
	> "$LOG_DIR/nightbot.log" 2>&1
kstart5 obs \
	> "$LOG_DIR/obs.log" 2>&1
google-chrome \
	--new-window \
	"https://www.twitch.tv/$TWITCH_CHANNEL/dashboard/live" \
	'http://localhost:25000/panel' \
	> "$LOG_DIR/dashboard-window.log" 2>&1

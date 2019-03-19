#!/bin/sh

TWITCH_CHANNEL=outfr0st

if [ -z "$BOT_COMMAND" ]; then
	if [ -z "$BOT_DESKTOP_FILE" ]; then
		BOT_DESKTOP_FILE="$HOME/.local/share/applications/PhantomBot.desktop"
	fi
	BOT_COMMAND="kstart5 --service $BOT_DESKTOP_FILE"
fi

if [ -z "$LOG_DIR" ]; then
	LOG_DIR='/tmp/livestream-tools/log'
fi

mkdir -p "$LOG_DIR"

echo "Starting chat bot"
$BOT_COMMAND \
	> "$LOG_DIR/bot.log" 2>&1

echo "Waiting up for chat bot's server to get ready"
sleep 3

echo "Starting Streamlabs recent events window"
kstart5 -- google-chrome \
	--app='https://streamlabs.com/dashboard/recent-events' \
	> "$LOG_DIR/streamlabs.log" 2>&1

echo "Starting Twitch chat window"
kstart5 -- google-chrome \
	--app="https://twitch.tv/popout/$TWITCH_CHANNEL/chat" \
	> "$LOG_DIR/twitch-chat.log" 2>&1

echo "Starting Twitch stream health window"
kstart5 -- google-chrome \
	--app="https://www.twitch.tv/popout/outfr0st/dashboard/live/stream-health" \
	> "$LOG_DIR/twitch-stream-health.log" 2>&1

echo "Starting Twitch video preview window"
kstart5 -- google-chrome \
	--app="https://www.twitch.tv/popout/outfr0st/dashboard/live/video-preview" \
	> "$LOG_DIR/twitch-video-preview.log" 2>&1

echo "Starting Twitch stream markers window"
kstart5 -- google-chrome \
	--app="https://www.twitch.tv/popout/outfr0st/dashboard/live/stream-marker" \
	> "$LOG_DIR/twitch-stream-markers.log" 2>&1

echo "Starting Nightbot dashboard"
kstart5 -- google-chrome \
	--app='https://beta.nightbot.tv/dashboard' \
	> "$LOG_DIR/nightbot.log" 2>&1

echo "Starting OBS Studio"
kstart5 obs \
	> "$LOG_DIR/obs.log" 2>&1

echo "Starting Twitch live dashboard and bot dashboard"
kstart5 -- google-chrome \
	--new-window \
	"https://www.twitch.tv/$TWITCH_CHANNEL/dashboard/live" \
	'http://localhost:25000/panel' \
	> "$LOG_DIR/dashboard-window.log" 2>&1

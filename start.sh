#!/usr/bin/sh

TWITCH_CHANNEL=outfrost

if [ -z "$BOT_COMMAND" ]; then
	BOT_COMMAND="phantombot"
fi

run() {  # command args...
	nohup "$@" </dev/null 1>&0 2>&0 &
}

if [ ! -t 1 ]; then
	konsole -e "$0" "$@"
	exit $?
fi

echo "Starting chat bot and system monitoring"
tmux new -s 'stream_chat_bot' "$BOT_COMMAND" \; new-window 'livestream-sensors' \; detach
sleep 0.1
echo
run ksysguard

echo "Waiting up for chat bot's server to get ready"
sleep 8

echo "Starting Streamlabs recent events window"
run firefox --ssb "https://streamlabs.com/dashboard/recent-events"

#echo "Starting Nightbot dashboard"
#browser_command "https://beta.nightbot.tv/dashboard"

echo "Starting Twitch Stream Manager"
run firefox --new-window "https://dashboard.twitch.tv/u/$TWITCH_CHANNEL/stream-manager"
#browser_command "https://dashboard.twitch.tv/u/$TWITCH_CHANNEL/stream-manager"

echo "Starting OBS Studio"
run obs

tmux attach -t 'stream_chat_bot'

# Prints the current time.

TMUS_POWERLINE_SEG_TIME_FORMAT_DEFAULT_CKYROUAC="%H:%M "

generate_segmentrc() {
	read -d '' rccontents  << EORC
# date(1) format for the time. Americans might want to have "%I:%M %p".
export TMUX_POWERLINE_SEG_TIME_FORMAT_CKYROUAC="${TMUS_POWERLINE_SEG_TIME_FORMAT_DEFAULT_CKYROUAC}"
# Change this to display a different timezone than the system default.
# Use TZ Identifier like "America/Los_Angeles"
export TMUX_POWERLINE_SEG_TIME_TZ_CKYROUAC=""
EORC
	echo "$rccontents"
}

__process_settings() {
	if [ -z "$TMUX_POWERLINE_SEG_TIME_FORMAT_CKYROUAC" ]; then
		export TMUX_POWERLINE_SEG_TIME_FORMAT_CKYROUAC="${TMUS_POWERLINE_SEG_TIME_FORMAT_DEFAULT_CKYROUAC}"
	fi
}

run_segment() {
        __process_settings
	if [ -n "$TMUX_POWERLINE_SEG_TIME_TZ_CKYROUAC" ]; then
		TZ="$TMUX_POWERLINE_SEG_TIME_TZ_CKYROUAC" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT_CKYROUAC"
	else
		date +"$TMUX_POWERLINE_SEG_TIME_FORMAT_CKYROUAC"
	fi
	return 0
}

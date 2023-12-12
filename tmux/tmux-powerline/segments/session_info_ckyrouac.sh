# Prints tmux session info.
# Assumes that [ -n "$TMUX"].

SEGMENT_FMT_CKYROUAC='#S '

generate_segmentrc() {
	read -d '' rccontents  << EORC
# Session info format to feed into the command: tmux display-message -p
# For example, if FORMAT is '[ #S ]', the command is: tmux display-message -p '[ #S ]'
export CKYROUAC_TMUX_SESSION_INFO_FMT="${SEGMENT_FMT_CKYROUAC}"
EORC
	echo "$rccontents"
}

__process_settings() {
	if [ -z "$CKYROUAC_TMUX_SESSION_INFO_FMT" ]; then
		export CKYROUAC_TMUX_SESSION_INFO_FMT="${SEGMENT_FMT_CKYROUAC}"
	fi
}

run_segment() {
	__process_settings
	tmux display-message -p "$CKYROUAC_TMUX_SESSION_INFO_FMT"
	return 0
}

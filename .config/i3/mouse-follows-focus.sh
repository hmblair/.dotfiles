#!/usr/bin/env bash
# Warp cursor to focused window on keyboard-driven focus changes

PIDFILE="/tmp/mouse-follows-focus.pid"

# Kill previous instance
if [[ -f "$PIDFILE" ]]; then
  old_pid=$(<"$PIDFILE")
  kill "$old_pid" 2>/dev/null
  wait "$old_pid" 2>/dev/null
fi

echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

i3-msg -t subscribe -m '["window"]' | while read -r event; do
  change=$(echo "$event" | grep -oP '"change"\s*:\s*"\K[^"]+')
  [[ "$change" != "focus" ]] && continue

  # Save mouse position before getwindowgeometry overwrites X/Y
  eval "$(xdotool getmouselocation --shell)"
  mouse_x=$X mouse_y=$Y

  win_id=$(xdotool getactivewindow 2>/dev/null) || continue
  eval "$(xdotool getwindowgeometry --shell "$win_id" 2>/dev/null)" || continue

  # If mouse is already inside the window, user probably clicked — skip
  if (( mouse_x >= X && mouse_x <= X + WIDTH && mouse_y >= Y && mouse_y <= Y + HEIGHT )); then
    continue
  fi

  # Warp to center of focused window
  xdotool mousemove --window "$win_id" $((WIDTH / 2)) $((HEIGHT / 2))
done

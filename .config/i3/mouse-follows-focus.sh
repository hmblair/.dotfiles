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
  [[ "$change" != "focus" && "$change" != "move" ]] && continue

  win_id=$(xdotool getactivewindow 2>/dev/null) || continue
  eval "$(xdotool getwindowgeometry --shell "$win_id" 2>/dev/null)" || continue

  # On focus events, skip if mouse is already inside (user probably clicked)
  if [[ "$change" == "focus" ]]; then
    eval "$(xdotool getmouselocation --shell 2>/dev/null)"
    mouse_x=$X mouse_y=$Y
    eval "$(xdotool getwindowgeometry --shell "$win_id" 2>/dev/null)" || continue
    if (( mouse_x >= X && mouse_x <= X + WIDTH && mouse_y >= Y && mouse_y <= Y + HEIGHT )); then
      continue
    fi
  fi

  # Warp to center of focused window
  xdotool mousemove --window "$win_id" $((WIDTH / 2)) $((HEIGHT / 2))
done

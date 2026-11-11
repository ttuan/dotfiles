#!/bin/bash
# Jump between herdr agents and remember where you came from:
#   herdr-agent-jump last   focus the last agent in the sidebar
#   herdr-agent-jump up     focus the previous/next agent in sidebar order,
#   herdr-agent-jump down   wrapping around at the ends
#   herdr-agent-jump back   focus the agent you jumped away from (toggles)
#   herdr-agent-jump next   focus the next agent waiting for you: blocked
#                           first, then done, longest-waiting first
#
# state_change_seq is a server-wide counter, so a lower value means the agent
# has been in its state longer. Viewing a done agent turns it idle, so
# repeated `next` presses work through the queue.
#
# Every jump saves the pane you left, so pressing `back` twice returns you to
# where you started. Only jumps made through this script are remembered; the
# built-in keys (prefix+alt+1..9, prefix+{ }) do not record anything.
set -eu

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/herdr"
state_file="$state_dir/agent-jump-prev"

list=$(herdr agent list)
current="${HERDR_ACTIVE_PANE_ID:-$(jq -r '.result.agents[] | select(.focused) | .pane_id' <<<"$list" | head -n1)}"

case "${1:-}" in
  last)
    target=$(jq -r '.result.agents[-1].pane_id // empty' <<<"$list")
    ;;
  up | down)
    # Step through agents in sidebar order, wrapping at both ends. From a
    # non-agent pane, down starts at the first agent and up at the last.
    target=$(jq -r --arg cur "$current" --arg dir "$1" '
      [.result.agents[].pane_id] as $ids
      | ($ids | length) as $n
      | (($ids | index($cur)) // -1) as $i
      | if $n == 0 then empty
        elif $dir == "down" then $ids[($i + 1) % $n]
        elif $i < 0 then $ids[$n - 1]
        else $ids[($i - 1 + $n) % $n] end' <<<"$list")
    ;;
  next)
    target=$(jq -r --arg cur "$current" '
      [.result.agents[]
        | select(.pane_id != $cur and (.agent_status == "blocked" or .agent_status == "done"))]
      | sort_by((if .agent_status == "blocked" then 0 else 1 end), .state_change_seq)
      | .[0].pane_id // empty' <<<"$list")
    ;;
  back)
    target=$(cat "$state_file" 2>/dev/null || true)
    # The saved agent may have been closed since
    jq -e --arg id "$target" 'any(.result.agents[]; .pane_id == $id)' <<<"$list" >/dev/null || exit 0
    ;;
  *)
    echo "usage: herdr-agent-jump last|back|next|up|down" >&2
    exit 1
    ;;
esac

[ -n "$target" ] && [ "$target" != "$current" ] || exit 0

mkdir -p "$state_dir"
[ -n "$current" ] && printf '%s\n' "$current" >"$state_file"
herdr agent focus "$target"

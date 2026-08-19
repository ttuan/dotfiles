#!/usr/bin/env bash
# Create a herdr workspace with 3 ready-made tabs: code / agents / console.
#
# Usage:
#   herdr-workspace-3tabs.sh                 # cwd = folder of the focused pane
#   herdr-workspace-3tabs.sh ~/code/my-project # explicit cwd
#   herdr-workspace-3tabs.sh . my-label      # custom workspace label
#
# With --here: reuse the CURRENT workspace, create the 3 tabs, then CLOSE the
# current tab (create first / close after, so the workspace is never left with
# 0 tabs).
# Warning: closing a tab kills the process running in it.

set -euo pipefail

TABS=(code agents console)

die() { printf '%s\n' "$*" >&2; exit 1; }
command -v herdr >/dev/null || die "herdr not found in PATH"

HERE=0
if [[ ${1:-} == "--here" ]]; then HERE=1; shift; fi

# --- cwd: argument > focused pane > $PWD -------------------------------------
focused_pane_cwd() {
  local snapshot
  snapshot=$(herdr pane list 2>/dev/null) || return 1
  jq -er '.result.panes[] | select(.focused == true) | .foreground_cwd // .cwd' \
    <<<"$snapshot" 2>/dev/null
}

focused_workspace_cwd() {
  local ws_id tab_id
  ws_id=$(herdr workspace list | jq -er '.result.workspaces[] | select(.focused) | .workspace_id') || return 1
  tab_id=$(herdr workspace list | jq -er '.result.workspaces[] | select(.focused) | .active_tab_id') || return 1
  herdr pane list | jq -er --arg t "$tab_id" \
    'first(.result.panes[] | select(.tab_id == $t)) | .foreground_cwd // .cwd'
}

CWD=${1:-}
if [[ -n $CWD ]]; then
  CWD=$(cd "$CWD" && pwd)
else
  CWD=$(focused_pane_cwd || focused_workspace_cwd || printf '%s' "$PWD")
fi
[[ -d $CWD ]] || die "cwd does not exist: $CWD"

LABEL=${2:-$(basename "$CWD")}

# --- create (or pick) the workspace ------------------------------------------
OLD_TAB=""
if (( HERE )); then
  focused=$(herdr workspace list | jq -er 'first(.result.workspaces[] | select(.focused))') \
    || die "--here needs a focused workspace"
  WS_ID=$(jq -er '.workspace_id' <<<"$focused")
  OLD_TAB=$(jq -er '.active_tab_id' <<<"$focused")
  FIRST_TAB=""
else
  created=$(herdr workspace create --cwd "$CWD" --label "$LABEL" --focus)
  WS_ID=$(jq -er '.result.workspace.workspace_id' <<<"$created")
  # workspace create already spawns 1 tab -> rename it into the first tab
  FIRST_TAB=$(jq -er '.result.tab.tab_id' <<<"$created")
fi

# A new workspace always comes with 1 tab -> rename it into the first tab
# instead of creating another one.
if [[ -n $FIRST_TAB ]]; then
  herdr tab rename "$FIRST_TAB" "${TABS[0]}" >/dev/null
fi

# --- the 3 tabs (idempotent) -------------------------------------------------
# Snapshot AFTER the rename: any tab that already has the right name is reused,
# so no duplicates are created.
snapshot=$(herdr tab list --workspace "$WS_ID")

tab_by_label() {
  jq -er --arg l "$1" 'first(.result.tabs[] | select(.label == $l)) | .tab_id' \
    <<<"$snapshot" 2>/dev/null || true
}

in_tabs() {
  local candidate=$1 name
  for name in "${TABS[@]}"; do
    [[ $candidate == "$name" ]] && return 0
  done
  return 1
}

focus_target=""
made=() kept=()
for name in "${TABS[@]}"; do
  tab_id=$(tab_by_label "$name")
  if [[ -n $tab_id ]]; then
    kept+=("$name")
  else
    tab_id=$(herdr tab create --workspace "$WS_ID" --cwd "$CWD" --label "$name" --no-focus \
      | jq -er '.result.tab.tab_id')
    made+=("$name")
  fi
  [[ -n $focus_target ]] || focus_target=$tab_id
done

herdr tab focus "$focus_target" >/dev/null

# Close the old tab AFTER the 3 tabs exist — unless it is itself one of the 3
# (pressing the key a second time while sitting in the code/agents/console tab).
if [[ -n $OLD_TAB ]]; then
  old_label=$(jq -r --arg t "$OLD_TAB" \
    'first(.result.tabs[] | select(.tab_id == $t)) | .label // ""' <<<"$snapshot")
  if in_tabs "$old_label"; then
    printf 'keeping current tab (%s): already part of the 3-tab set\n' "$old_label"
  else
    herdr tab close "$OLD_TAB" >/dev/null
  fi
fi

printf 'workspace %s @ %s | created: %s | reused: %s\n' \
  "$WS_ID" "$CWD" "${made[*]:-(none)}" "${kept[*]:-(none)}"

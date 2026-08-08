#!/usr/bin/env bash
# Tao workspace herdr voi 3 tab co san: code / agents / console.
#
# Dung:
#   herdr-workspace-3tabs.sh                 # cwd = folder cua pane dang focus
#   herdr-workspace-3tabs.sh ~/code/my-project # cwd chi dinh
#   herdr-workspace-3tabs.sh . my-label      # label workspace tuy chon
#
# Voi --here: dung workspace DANG mo, tao 3 tab roi DONG tab hien tai
# (tao truoc / dong sau, de workspace khong bao gio con 0 tab).
# Canh bao: dong tab se kill process dang chay trong tab do.

set -euo pipefail

TABS=(code agents console)

die() { printf '%s\n' "$*" >&2; exit 1; }
command -v herdr >/dev/null || die "khong tim thay herdr trong PATH"

HERE=0
if [[ ${1:-} == "--here" ]]; then HERE=1; shift; fi

# --- cwd: tham so > pane dang focus > $PWD ------------------------------------
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
[[ -d $CWD ]] || die "cwd khong ton tai: $CWD"

LABEL=${2:-$(basename "$CWD")}

# --- tao (hoac chon) workspace ------------------------------------------------
OLD_TAB=""
if (( HERE )); then
  focused=$(herdr workspace list | jq -er 'first(.result.workspaces[] | select(.focused))') \
    || die "--here can mot workspace dang focus"
  WS_ID=$(jq -er '.workspace_id' <<<"$focused")
  OLD_TAB=$(jq -er '.active_tab_id' <<<"$focused")
  FIRST_TAB=""
else
  created=$(herdr workspace create --cwd "$CWD" --label "$LABEL" --focus)
  WS_ID=$(jq -er '.result.workspace.workspace_id' <<<"$created")
  # workspace create da sinh san 1 tab -> doi ten thanh tab dau tien
  FIRST_TAB=$(jq -er '.result.tab.tab_id' <<<"$created")
fi

# Workspace moi luon kem 1 tab -> doi ten no thanh tab dau tien thay vi tao them.
if [[ -n $FIRST_TAB ]]; then
  herdr tab rename "$FIRST_TAB" "${TABS[0]}" >/dev/null
fi

# --- 3 tab (idempotent) -------------------------------------------------------
# Snapshot SAU rename: tab nao da co dung ten thi dung lai, khong tao trung.
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

# Dong tab cu SAU khi 3 tab da ton tai — tru khi chinh no la mot trong 3 tab
# (bam nham lan 2 khi dang dung trong tab code/agents/console).
if [[ -n $OLD_TAB ]]; then
  old_label=$(jq -r --arg t "$OLD_TAB" \
    'first(.result.tabs[] | select(.tab_id == $t)) | .label // ""' <<<"$snapshot")
  if in_tabs "$old_label"; then
    printf 'giu tab hien tai (%s): da nam trong bo 3 tab\n' "$old_label"
  else
    herdr tab close "$OLD_TAB" >/dev/null
  fi
fi

printf 'workspace %s @ %s | tao: %s | dung lai: %s\n' \
  "$WS_ID" "$CWD" "${made[*]:-(khong)}" "${kept[*]:-(khong)}"

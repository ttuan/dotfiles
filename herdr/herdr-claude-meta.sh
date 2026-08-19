#!/bin/sh
# Push the session name + Claude account identity + 5h quota to the herdr sidebar.
#
# Invoked from the end of every ~/.claude*/statusline-command.sh, in the
# background. All the values have already been computed by the statusline; this
# script only reformats and sends them - it calls no API of its own.
#
# The sidebar reads them through the $convo / $acct / $quota_ok / $quota_warn /
# $quota_crit tokens, declared in [ui.sidebar.agents.rows_by_agent] of
# config.toml.
#
# The quota has to be split into 3 tokens because style tokens in the config are
# static: on each run only one token gets a value and the other two are sent as
# null to clear them. That is the only way to change color by threshold.
#
# Silent no-op when not running inside herdr. Never prints anything, never exits
# non-zero - this is a side job of the statusline.

set -eu

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
[ -n "${HERDR_SOCKET_PATH:-}" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

CLAUDE_META_EMAIL=""
CLAUDE_META_ORG=""
CLAUDE_META_FIVE_PCT=""
CLAUDE_META_FIVE_RESET=""
CLAUDE_META_TRANSCRIPT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --email)      [ $# -ge 2 ] || break; CLAUDE_META_EMAIL="$2";      shift 2 ;;
    --org)        [ $# -ge 2 ] || break; CLAUDE_META_ORG="$2";        shift 2 ;;
    --five-pct)   [ $# -ge 2 ] || break; CLAUDE_META_FIVE_PCT="$2";   shift 2 ;;
    --five-reset) [ $# -ge 2 ] || break; CLAUDE_META_FIVE_RESET="$2"; shift 2 ;;
    --transcript) [ $# -ge 2 ] || break; CLAUDE_META_TRANSCRIPT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

export CLAUDE_META_EMAIL CLAUDE_META_ORG CLAUDE_META_FIVE_PCT
export CLAUDE_META_FIVE_RESET CLAUDE_META_TRANSCRIPT

python3 - <<'PY' || exit 0
import json
import os
import random
import re
import socket
import time
import unicodedata
from datetime import datetime, timezone

SOURCE = "claude-meta"
# The sidebar is 26 columns wide by default (ui.sidebar_width). Longer strings
# get truncated.
WIDTH = 26
# Row 1 also has to hold the workspace name, so the session name is clipped
# shorter. herdr clips further with "…" if it still does not fit.
CONVO_WIDTH = 22
# Longer than the 5h window, so a live pane never hits the limit; a dead pane
# has its row disappear instead of hanging on to stale numbers forever.
TTL_MS = 6 * 60 * 60 * 1000

pane_id = os.environ.get("HERDR_PANE_ID") or ""
socket_path = os.environ.get("HERDR_SOCKET_PATH") or ""
if not pane_id or not socket_path:
    raise SystemExit(0)


def cells(text):
    """Measure real terminal width; emoji take 2 cells."""
    return sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in text)


def clip(text, budget):
    """Truncate the tail to fit the budget, appending an ellipsis."""
    if cells(text) <= budget:
        return text
    out = ""
    for ch in text:
        if cells(out + ch) > budget - 1:
            break
        out += ch
    return out + "…"


def shrink_middle(text, budget):
    """Cut the middle out to keep both head and tail - used for email local parts."""
    if cells(text) <= budget or budget < 3:
        return text
    keep = budget - 1
    head = (keep + 1) // 2
    tail = keep - head
    return text[:head] + "…" + (text[-tail:] if tail else "")


def build_acct(email, org):
    if not email:
        return None
    local = email.split("@", 1)[0]

    # Personal accounts get an auto-generated org named "<email>'s Organization",
    # which carries no information. Drop it, keep only a real org.
    org = (org or "").strip()
    for suffix in ("'s Organization", "’s Organization"):
        if org.endswith(suffix):
            org = org[: -len(suffix)]
            break
    if org == email or org == local:
        org = ""

    prefix = "\U0001f464 "
    if org:
        tail = " · " + org
        room = WIDTH - cells(prefix) - cells(tail)
        if room < 6:
            # Org too long, no room left for the local part: clip the whole thing.
            return clip(prefix + local + tail, WIDTH)
        return prefix + shrink_middle(local, room) + tail
    return clip(prefix + local, WIDTH)


def humanize(reset_raw):
    """ISO8601 (or epoch) -> '1d2h' / '3h12m' / '47m'. Empty if already past."""
    reset_raw = (reset_raw or "").strip()
    if not reset_raw:
        return ""
    try:
        if reset_raw.isdigit():
            when = datetime.fromtimestamp(int(reset_raw), tz=timezone.utc)
        else:
            cleaned = re.sub(r"\.\d+", "", reset_raw).replace("Z", "+00:00")
            when = datetime.fromisoformat(cleaned)
            if when.tzinfo is None:
                when = when.replace(tzinfo=timezone.utc)
    except (ValueError, OverflowError, OSError):
        return ""

    left = int((when - datetime.now(timezone.utc)).total_seconds())
    if left <= 0:
        return ""
    days, rem = divmod(left, 86400)
    hours, rem = divmod(rem, 3600)
    minutes = rem // 60
    if days:
        return "%dd%dh" % (days, hours)
    if hours:
        return "%dh%dm" % (hours, minutes)
    return "%dm" % minutes


def rpc(method, params):
    """One JSON-RPC round trip over herdr's unix socket. None on failure."""
    request = {
        "id": "%s:%d:%06d"
        % (SOURCE, int(time.time() * 1000), random.randrange(1_000_000)),
        "method": method,
        "params": params,
    }
    try:
        client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        client.settimeout(0.5)
        client.connect(socket_path)
        client.sendall((json.dumps(request) + "\n").encode())
        buf = b""
        while b"\n" not in buf:
            chunk = client.recv(4096)
            if not chunk:
                break
            buf += chunk
        client.close()
    except OSError:
        return None
    if not buf:
        return None
    try:
        return json.loads(buf.split(b"\n", 1)[0].decode())
    except ValueError:
        return None


def custom_title(transcript_path):
    """The session name a HUMAN set via /rename, or None.

    Claude Code writes two kinds of name records into the transcript:
    `ai-title` (auto-generated, constantly changing with whatever is being
    worked on) and `custom-title` (only produced by running /rename). The
    `session_name` field in the statusline payload can NOT be used to tell them
    apart, because it always has a value - before /rename it is simply the
    ai-title. So the transcript has to be read.

    Filter by substring before parsing JSON: scanning an entire 950KB file takes
    ~2ms.
    """
    if not transcript_path or not os.path.isfile(transcript_path):
        return None
    found = None
    try:
        with open(transcript_path, encoding="utf-8", errors="replace") as handle:
            for line in handle:
                if '"custom-title"' not in line:
                    continue
                try:
                    record = json.loads(line)
                except ValueError:
                    continue
                if record.get("type") == "custom-title":
                    title = (record.get("customTitle") or "").strip()
                    if title:
                        found = title
    except OSError:
        return None
    return found


def tab_label():
    """Name of the tab holding this pane - the fallback when the session has no /rename.

    Take tab_id from pane.get rather than from $HERDR_TAB_ID, because that env
    var is set when the pane is created and goes stale if the pane is moved to
    another tab.
    """
    tab_id = ""
    pane = rpc("pane.get", {"pane_id": pane_id})
    if pane:
        tab_id = (pane.get("result") or {}).get("pane", {}).get("tab_id") or ""
    tab_id = tab_id or os.environ.get("HERDR_TAB_ID") or ""
    if not tab_id:
        return None
    tab = rpc("tab.get", {"tab_id": tab_id})
    if not tab:
        return None
    return (tab.get("result") or {}).get("tab", {}).get("label") or None


def build_convo(transcript_path):
    name = custom_title(transcript_path) or tab_label()
    if not name:
        return None
    return clip(name.strip(), CONVO_WIDTH)


def build_quota(pct_raw, reset_raw):
    """Return (token_name, string). The token name decides the color in config.toml."""
    pct_raw = (pct_raw or "").strip()
    if not pct_raw:
        return None, None
    try:
        pct = int(round(float(pct_raw)))
    except ValueError:
        return None, None

    left = humanize(reset_raw)
    text = "\U0001f4ca 5h %d%%" % pct
    if left:
        text += " (%s)" % left

    if pct >= 90:
        return "quota_crit", clip(text, WIDTH)
    if pct >= 70:
        return "quota_warn", clip(text, WIDTH)
    return "quota_ok", clip(text, WIDTH)


tokens = {
    "convo": build_convo(os.environ.get("CLAUDE_META_TRANSCRIPT", "")),
    "acct": build_acct(
        os.environ.get("CLAUDE_META_EMAIL", ""),
        os.environ.get("CLAUDE_META_ORG", ""),
    ),
    "quota_ok": None,
    "quota_warn": None,
    "quota_crit": None,
}
name, text = build_quota(
    os.environ.get("CLAUDE_META_FIVE_PCT", ""),
    os.environ.get("CLAUDE_META_FIVE_RESET", ""),
)
if name:
    tokens[name] = text

rpc(
    "pane.report_metadata",
    {
        "pane_id": pane_id,
        "source": SOURCE,
        # Nanosecond clock so a late report does not overwrite a newer one.
        "seq": time.time_ns(),
        "ttl_ms": TTL_MS,
        "tokens": tokens,
    },
)
PY

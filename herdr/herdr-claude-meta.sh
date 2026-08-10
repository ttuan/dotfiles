#!/bin/sh
# Day dinh danh account Claude + quota 5h sang sidebar herdr.
#
# Duoc goi tu cuoi moi ~/.claude*/statusline-command.sh, chay nen. Cac gia tri
# deu da duoc statusline tinh san, script nay chi format lai va gui di - no
# khong tu goi API nao ca.
#
# Sidebar doc chung qua token $acct / $quota_ok / $quota_warn / $quota_crit,
# khai bao trong [ui.sidebar.agents.rows_by_agent] cua config.toml.
#
# Quota phai tach lam 3 token vi style token trong config la tinh: moi lan chi
# mot token co gia tri, hai token con lai gui null de xoa. Do la cach duy nhat
# de doi mau theo nguong.
#
# No-op im lang khi khong chay trong herdr. Khong bao gio in ra gi, khong bao
# gio thoat khac 0 - day la phan phu cua statusline.

set -eu

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
[ -n "${HERDR_SOCKET_PATH:-}" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

CLAUDE_META_EMAIL=""
CLAUDE_META_ORG=""
CLAUDE_META_FIVE_PCT=""
CLAUDE_META_FIVE_RESET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --email)      [ $# -ge 2 ] || break; CLAUDE_META_EMAIL="$2";      shift 2 ;;
    --org)        [ $# -ge 2 ] || break; CLAUDE_META_ORG="$2";        shift 2 ;;
    --five-pct)   [ $# -ge 2 ] || break; CLAUDE_META_FIVE_PCT="$2";   shift 2 ;;
    --five-reset) [ $# -ge 2 ] || break; CLAUDE_META_FIVE_RESET="$2"; shift 2 ;;
    *) shift ;;
  esac
done

export CLAUDE_META_EMAIL CLAUDE_META_ORG CLAUDE_META_FIVE_PCT CLAUDE_META_FIVE_RESET

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
# Sidebar mac dinh rong 26 cot (ui.sidebar_width). Chuoi dai hon se bi cat.
WIDTH = 26
# Dai hon cua so 5h, nen pane con song khong bao gio cham nguong; pane da chet
# thi hang cua no tu bien mat thay vi treo so cu mai mai.
TTL_MS = 6 * 60 * 60 * 1000

pane_id = os.environ.get("HERDR_PANE_ID") or ""
socket_path = os.environ.get("HERDR_SOCKET_PATH") or ""
if not pane_id or not socket_path:
    raise SystemExit(0)


def cells(text):
    """Do be ngang thuc te tren terminal, emoji chiem 2 o."""
    return sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in text)


def clip(text, budget):
    """Cat duoi cho vua budget o, chen dau ellipsis."""
    if cells(text) <= budget:
        return text
    out = ""
    for ch in text:
        if cells(out + ch) > budget - 1:
            break
        out += ch
    return out + "…"


def shrink_middle(text, budget):
    """Cat giua chuoi de giu ca dau va duoi - dung cho local-part cua email."""
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

    # Tai khoan ca nhan duoc cap mot org tu sinh ten "<email>'s Organization",
    # khong mang thong tin gi. Bo di, chi giu org that.
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
            # Org qua dai, khong con cho cho local-part: cat ca cum.
            return clip(prefix + local + tail, WIDTH)
        return prefix + shrink_middle(local, room) + tail
    return clip(prefix + local, WIDTH)


def humanize(reset_raw):
    """ISO8601 (hoac epoch) -> '1d2h' / '3h12m' / '47m'. Rong neu da qua han."""
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


def build_quota(pct_raw, reset_raw):
    """Tra ve (ten_token, chuoi). Ten token quyet dinh mau trong config.toml."""
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

request = {
    "id": "%s:%d:%06d" % (SOURCE, int(time.time() * 1000), random.randrange(1_000_000)),
    "method": "pane.report_metadata",
    "params": {
        "pane_id": pane_id,
        "source": SOURCE,
        # Dong ho nano de bao cao den muon khong ghi de bao cao moi hon.
        "seq": time.time_ns(),
        "ttl_ms": TTL_MS,
        "tokens": tokens,
    },
}

try:
    client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client.settimeout(0.5)
    client.connect(socket_path)
    client.sendall((json.dumps(request) + "\n").encode())
    try:
        client.recv(4096)
    except OSError:
        pass
    client.close()
except OSError:
    pass
PY

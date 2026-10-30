#!/usr/bin/env python3
"""Local-only Codex -> Herdr metadata hook. No API calls or token logging."""
import base64
import json
import math
import os
from pathlib import Path
import socket
import sys
import time
import unicodedata


def clip(value, width=26):
    text = ''.join(c for c in str(value) if not unicodedata.category(c).startswith('C'))
    out, size = '', 0
    for c in text:
        size += 0 if unicodedata.combining(c) else (2 if unicodedata.east_asian_width(c) in 'WF' else 1)
        if size > width - 1:
            return out + '…'
        out += c
    return out


def read_json(path):
    try:
        return json.loads(path.read_text())
    except (OSError, ValueError):
        return {}


def account(home):
    auth = read_json(home / 'auth.json')
    if auth.get('auth_mode') == 'apikey':
        return '👤 API key'
    try:
        token = auth.get('tokens', {}).get('id_token', '')
        segment = token.split('.')[1]
        claims = json.loads(base64.urlsafe_b64decode(segment + '=' * (-len(segment) % 4)))
        email = claims.get('email') or claims.get('https://api.openai.com/profile', {}).get('email')
        plan = claims.get('https://api.openai.com/auth', {}).get('chatgpt_plan_type')
        if email:
            return clip('👤 ' + email.split('@')[0] + (' · ' + plan if plan else ''))
    except (ValueError, IndexError, TypeError):
        pass
    return None


def quota(path, now):
    # Read a bounded tail, discard a partial first line. Never search another
    # session: its limits may belong to a different account or model.
    try:
        with Path(path).open('rb') as f:
            size = f.seek(0, 2)
            f.seek(max(0, size - 2 * 1024 * 1024))
            if size > 2 * 1024 * 1024:
                f.readline()
            lines = f.read().splitlines()
    except (OSError, TypeError):
        return None, None
    for line in reversed(lines):
        try:
            record = json.loads(line)
            payload = record.get('payload', {})
            if record.get('type') != 'event_msg' or payload.get('type') != 'token_count':
                continue
            limits = payload.get('rate_limits') or {}
            if limits.get('limit_id') not in (None, 'codex'):
                continue
            windows = [limits.get('primary'), limits.get('secondary')]
            window = next((w for w in windows if isinstance(w, dict) and w.get('window_minutes') == 300), None)
            if not window:
                continue
            pct = float(window['used_percent'])
            reset = float(window['resets_at'])
            if not math.isfinite(pct) or not 0 <= pct <= 100 or not math.isfinite(reset) or reset <= now:
                return None, None
            minutes = int((reset - now) / 60)
            left = f'{minutes // 60}h{minutes % 60}m' if minutes >= 60 else f'{minutes}m'
            key = 'quota_crit' if pct >= 90 else 'quota_warn' if pct >= 70 else 'quota_ok'
            return key, clip(f'📊 5h {pct:.0f}% ({left})')
        except (ValueError, TypeError, KeyError, AttributeError):
            continue
    return None, None


def rpc(method, params):
    request = {'id': f'codex-meta:{time.time_ns()}', 'method': method, 'params': params}
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.settimeout(0.5)
        client.connect(os.environ['HERDR_SOCKET_PATH'])
        client.sendall((json.dumps(request) + '\n').encode())
        client.recv(4096)


def main():
    if os.environ.get('HERDR_ENV') != '1' or not all(os.environ.get(k) for k in ('HERDR_PANE_ID', 'HERDR_SOCKET_PATH')):
        return
    payload = json.load(sys.stdin)
    if not isinstance(payload, dict) or payload.get('agent_id') or payload.get('hook_event_name') == 'SubagentStop':
        return
    home = Path(os.environ.get('CODEX_HOME') or Path.home() / '.codex').expanduser()
    pane = os.environ['HERDR_PANE_ID']
    tokens = dict.fromkeys(('acct', 'quota_ok', 'quota_warn', 'quota_crit'))
    ended = payload.get('hook_event_name') == 'SessionEnd'
    if not ended:
        tokens['acct'] = account(home)
        name, value = quota(payload.get('transcript_path'), time.time())
        if name:
            tokens[name] = value
    # Codex hooks run on lifecycle/tool events rather than every statusline
    # render. Keep the last known account/quota visible between events, like
    # the Claude integration does; a later hook refreshes the quota.
    rpc('pane.report_metadata', {'pane_id': pane, 'source': 'codex-meta', 'seq': time.time_ns(),
                                'ttl_ms': 6 * 60 * 60 * 1000, 'tokens': tokens})
    if payload.get('hook_event_name') == 'SessionStart' and payload.get('session_id'):
        params = {'pane_id': pane, 'source': 'herdr:codex', 'agent': 'codex',
                  'seq': time.time_ns(), 'agent_session_id': payload['session_id']}
        if payload.get('transcript_path'):
            params['agent_session_path'] = payload['transcript_path']
        rpc('pane.report_agent_session', params)


if __name__ == '__main__':
    try:
        main()
    except Exception:
        # Metadata must never block prompts, grant approvals, or emit context.
        pass

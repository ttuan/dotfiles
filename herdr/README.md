# herdr - terminal workspace manager for AI agents

Manages workspaces/tabs/panes for AI agent sessions running in parallel, with a
sidebar showing the state of each agent (working / done / blocked / idle).
Home page: https://herdr.dev

## Files

| File | What it is |
|---|---|
| `config.toml` | Main configuration. Symlinked to `~/.config/herdr/config.toml`. Contains tmux-style keybindings, tokyo-night theme with tweaked colors, and the sidebar layout. |
| `herdr-workspace-3tabs.sh` | Creates the `code` / `agents` / `console` tab set at the currently focused cwd. Symlinked to `~/.local/bin/herdr-workspace-3tabs`. Bound to `prefix+t` (replace the current tab) and `prefix+shift+t` (new workspace). |
| `herdr-claude-meta.sh` | Pushes the session name + Claude account email + 5h quota to the sidebar. Symlinked to `~/.local/bin/herdr-claude-meta`. See its own section below. |

Only `config.toml` is symlinked into `~/.config/herdr/`; that directory also
holds the socket, logs and session state, so the whole directory is not
symlinked.

## Installing on a new machine

```bash
cd ~/code/dotfiles && ./install     # dotbot creates all 3 symlinks
herdr --version                     # confirm the binary is present
herdr config check                  # must print "config: ok"
```

The `herdr` binary is installed separately (`~/.local/bin/herdr`); it does not
live in this repo. After changing `config.toml` there is no need to restart the
session:

```bash
herdr server reload-config          # must return status: "applied"
```

## Sidebar for Claude panes

When several Claude accounts run in parallel — one config dir each, `~/.claude`
plus a `~/.claude-<name>` dir per extra account — there is no way to tell which
pane is using which account, nor how much quota that account has burned. The
agent block for a Claude pane therefore has 4 rows instead of 2:

```
|<--------- 26 columns ----->|
my-project          agents   <- workspace + session name (or tab name)
⠐ working           claude
👤 alice
📊 5h 23% (43m)
```

The color of the quota row follows thresholds: green `< 70%`, orange `70-89%`,
red `>= 90%`.

### Row 1: session name instead of tab name

Row 1 uses the `$convo` token rather than the built-in `tab` token:

1. If the session has been named with **`/rename`**, show that name.
2. Otherwise fall back to the **tab name**, i.e. exactly the old behavior.

`session_name` from the statusline payload can **not** be used to distinguish
the two cases: that field always has a value, and before `/rename` it is the
AI-generated name (`ai-title`, which keeps changing with whatever is being
worked on). Only `/rename` writes a `{"type":"custom-title","customTitle":...}`
record into the transcript, so the script reads `transcript_path` to find it.
Filtering by substring before parsing JSON keeps it cheap: scanning an entire
950KB file takes about 2ms.

The config has no conditional clauses, so the script has to make the choice
itself and push a single token. Two consequences follow:

- Renaming a tab with `prefix+,` only shows up on the next statusline render,
  not immediately.
- If the script breaks, row 1 loses the tab name. The token has a `ttl_ms` of
  6 hours, so the last value stays there in the meantime.

### How it works

```
Claude Code (pane, CLAUDE_CONFIG_DIR=~/.claude-<name>)
   |  on every statusline render
   v
~/.claude-<name>/statusline-command.sh
   |  already has $account_email, $account_org, $FIVE_H, $FIVE_H_RESET
   |  + .transcript_path taken from the stdin payload
   |  the block is invoked at the end of the file, in the background (&)
   v
~/.local/bin/herdr-claude-meta
   |  reads $HERDR_PANE_ID + $HERDR_SOCKET_PATH from the pane's env
   |  reads the transcript for custom-title; if absent, asks herdr for the tab name
   v
unix socket -> herdr server: pane.report_metadata
   v
sidebar row 1 (session name) + rows 3, 4
```

Each pane reports its own metadata, so there is no need to manually map "which
config dir corresponds to which pane" - whichever account runs in whichever pane
is automatically correct.

The script calls no API of its own; it only reformats values the statusline has
already computed. Outside herdr it is a silent no-op (exits 0, prints nothing).

### MANDATORY manual step on a new machine

The file `~/.claude/statusline-command.sh` is **not in this repo** (it reads a
separate keychain entry per account), so dotbot cannot be used for it. The
following block must be added by hand at the **end of the file**:

```sh
# ─────────────────────────────────────────────────────────────
# Push the session name + account identity + 5h quota to the herdr sidebar
# (rows 1, 3, 4 of the agent block). Runs in the background so it does not slow
# down the statusline; no-op when not inside herdr.
# Script: ~/code/dotfiles/herdr/herdr-claude-meta.sh
# ─────────────────────────────────────────────────────────────
if [ -x "$HOME/.local/bin/herdr-claude-meta" ]; then
  "$HOME/.local/bin/herdr-claude-meta" \
    --email "$ACTIVE_EMAIL" \
    --org "$(echo "$AUTH_STATUS" | jq -r '.orgName // empty')" \
    --five-pct "$FIVE_H" \
    --five-reset "$FIVE_H_RESET" \
    --transcript "$(echo "$input" | jq -r '.transcript_path // empty')" \
    >/dev/null 2>&1 &
fi
```

**Do this ONCE, not for each config dir.** Every `~/.claude*` config dir runs
this same file: the extra ones symlink `settings.json` to
`~/.claude/settings.json`, and the
`statusLine.command` in it is the absolute path
`~/.claude/statusline-command.sh` (the leading `~` expands to `$HOME`, not to the
config dir). Adding the block above to each dir would push twice.

Accounts can still be told apart per pane because the statusline is itself
multi-account: it takes `CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"` and
looks up the keychain entry for that dir, so `$ACTIVE_EMAIL` is always the
account of the running pane.

To re-check when in doubt:

```bash
for d in "$HOME"/.claude "$HOME"/.claude-*; do
  [ -f "$d/settings.json" ] || continue
  printf '%-20s %s\n' "$(basename "$d")" "$(jq -r '.statusLine.command' "$d/settings.json")"
done
grep -c herdr-claude-meta "$HOME/.claude/statusline-command.sh"   # must be > 0
```

**Variable names differ from the original README.** The current statusline names
it `ACTIVE_EMAIL` (not `account_email`) and does not expose the org separately -
`orgName` has to be dug out of `$AUTH_STATUS`. `FIVE_H`, `FIVE_H_RESET` and the
stdin payload in `$input` are unchanged. **If the statusline is rewritten and
the variable names change, this block must be updated to match.**

### Verifying

```bash
herdr config check                        # config: ok
herdr server reload-config                # status: "applied"

# Push a test value into the current pane (must be run INSIDE herdr)
herdr-claude-meta --email a@b.com --five-pct 95 --five-reset ""

# Read back the tokens now sitting on the pane
herdr pane get "$HERDR_PANE_ID" | python3 -m json.tool | grep -A5 tokens
```

The expected result is `{"acct": "👤 a", "quota_crit": "📊 5h 95%"}`. Change
`--five-pct` to `42` / `78` to try all three color levels.

With real Claude Code, the tokens only appear after that pane's first
**statusline render**, i.e. as soon as the session does anything. A pane that has
been sitting idle since before the install will show nothing until the next
interaction - this is normal and happens only once per already-open pane.

### Why the quota needs 3 tokens

Style tokens in `config.toml` are **static** (`RawStyledSidebarToken` only has
`token`, `fg`, `bold`, `dim`); they cannot change color by value the way
`state_icon`/`state_text` do - those two are built-in tokens that herdr colors
by state. The workaround: declare three token names for the three levels
(`$quota_ok`, `$quota_warn`, `$quota_crit`), each with a fixed color; on every
run the script fills exactly one of them and sends `null` for the other two to
clear them. The result looks exactly like a dynamic color.

For the same reason the width must stay <= 26 columns (`ui.sidebar_width`
defaults to 26, max 36): the script shortens the local part of the email itself,
inserting `…` in the middle.

### Troubleshooting

| Symptom | Common cause |
|---|---|
| No rows show up at all | `herdr server reload-config` was not run after changing `config.toml`. |
| Shows in one pane but not another | The other pane has never rendered its statusline. Type something into it. |
| `herdr config check` reports `unknown sidebar token` | Wrong token name in `rows_by_agent`; it must have the `$` prefix. |
| Stale numbers still shown after quitting Claude | The token has a `ttl_ms` of 6 hours and then expires by itself. To clear it now, push again with empty values. |
| Row 1 loses the tab name | The script could not push `$convo`. Check whether `--transcript` is being passed, and whether `herdr tab get "$HERDR_TAB_ID"` returns a `label`. |
| Already ran `/rename` but the tab name still shows | That session has not re-rendered its statusline. Or the transcript has not written `custom-title` yet - check with `grep -c custom-title <transcript>`. |
| Running `herdr-claude-meta` shows nothing | Correct - it is a no-op when `HERDR_ENV=1` / `HERDR_PANE_ID` / `HERDR_SOCKET_PATH` are missing, i.e. when not inside herdr. |

Do not use the `herdr pane report-metadata` CLI in place of the script: the
parser in 0.8.0 is inconsistent (`--source` must be written as `--source=X`,
`--token` is the opposite, and a positional pane_id is rejected). Going straight
to the JSON-RPC socket is more reliable.

## Detailed design

`../claude/docs/superpowers/specs/2026-08-10-herdr-sidebar-account-quota-design.md`

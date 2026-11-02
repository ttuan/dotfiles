# herdr - terminal workspace manager for AI agents

Manages workspaces/tabs/panes for AI agent sessions running in parallel, with a
sidebar showing the state of each agent (working / done / blocked / idle).
Home page: https://herdr.dev

## Files

| File | What it is |
|---|---|
| `config.toml` | Main configuration. Symlinked to `~/.config/herdr/config.toml`. Contains tmux-style keybindings, the tokyo-night theme with Deep Harbor accents, and the sidebar layout. |
| `herdr-workspace-3tabs.sh` | Creates the `code` / `agents` / `console` tab set at the currently focused cwd. Symlinked to `~/.local/bin/herdr-workspace-3tabs`. Bound to `prefix+t` (replace the current tab) and `prefix+shift+t` (new workspace). |

Only `config.toml` is symlinked into `~/.config/herdr/`; that directory also
holds the socket, logs and session state, so the whole directory is not
symlinked.

## Sidebar: account and quota per pane

The 4-row agent block for Claude and Codex panes (session name, account, 5h
quota) now lives in
[claude-toolbox](https://github.com/ttuan/claude-toolbox/tree/main/integrations/herdr):
the `herdr-claude-meta` and `herdr-codex-meta` scripts, the canonical
`sidebar.toml`, the Codex hooks and the full explanation.

This repo keeps its own copy of the sidebar section inside `config.toml`,
because herdr reads a single config file. When changing the sidebar, change it
in claude-toolbox first, then copy it here.

## Installing on a new machine

Clone claude-toolbox first: the dotbot links for the two metadata scripts point
into it.

```bash
git clone git@github.com:ttuan/claude-toolbox.git ~/code/claude-toolbox
cd ~/code/dotfiles && ./install     # dotbot creates the 4 symlinks
herdr --version                     # confirm the binary is present
herdr config check                  # must print "config: ok"
```

The Claude side needs nothing more when the claude-toolbox status line is in
use: it calls `herdr-claude-meta` on every render. For Codex, follow the Codex
section of the claude-toolbox README.

The `herdr` binary is installed separately (`~/.local/bin/herdr`); it does not
live in this repo. After changing `config.toml` there is no need to restart the
session:

```bash
herdr server reload-config          # must return status: "applied"
```

## Detailed design

`../claude/docs/superpowers/specs/2026-08-10-herdr-sidebar-account-quota-design.md`

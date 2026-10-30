# dotfiles Claude Code plugins

A local Claude Code marketplace (directory source) tracked in dotfiles.

## Plugins

- **bash-syntax** — redraws tool-call rows (`⏺ Bash(...)`, `Read`, `Edit`,
  `Write`, `Glob`, `Grep`) with syntax colouring. Toggle per session with
  `/bash-syntax`, or set the default in `/config`.

## Install

Install into the primary config dir only:

```bash
bash ~/code/dotfiles/claude/plugins/install.sh
```

Plugin enable state lives in `~/.claude/settings.json` (`enabledPlugins` and
`extraKnownMarketplaces`). Any account whose `settings.json` is a symlink to
`~/.claude/settings.json` inherits the plugin automatically — there is no
per-account install.

## A new account

When you add another config dir, share the plugin by symlinking its
`settings.json` back to the primary one (the same way the other shared files are
linked):

```bash
ln -s ~/.claude/settings.json ~/.claude-<name>/settings.json
```

## Update after editing a plugin

```bash
claude plugin marketplace update dotfiles
```

Then start a new Claude Code session.

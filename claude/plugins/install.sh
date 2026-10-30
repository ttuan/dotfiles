#!/usr/bin/env bash
# Install the dotfiles-tracked Claude Code plugin(s) into the primary Claude
# config dir (~/.claude) only.
#
# Plugin enable state and marketplace declarations live in ~/.claude/settings.json
# (enabledPlugins + extraKnownMarketplaces). Other accounts that symlink that file
# back to ~/.claude pick the plugin up automatically — nothing to install per
# account. This script therefore targets ~/.claude and nothing else; it does not
# know or care which other config dirs exist on the machine.
#
#   bash ~/code/dotfiles/claude/plugins/install.sh
set -uo pipefail

MARKET="$HOME/code/dotfiles/claude/plugins"
PLUGIN="bash-syntax"

CLAUDE_CONFIG_DIR="$HOME/.claude" \
  claude plugin install "$PLUGIN" --marketplace "$MARKET" -s user \
  && echo "Installed $PLUGIN into ~/.claude." \
  || { echo "!! install failed"; exit 1; }

echo
echo "Accounts that symlink ~/.claude/settings.json share the enable state, so"
echo "they get it automatically. Start a new Claude Code session and run a tool"
echo "call to see it. Toggle with /bash-syntax, or /config > Highlight tool rows."

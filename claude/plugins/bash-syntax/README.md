# bash-syntax

A Claude Code mod that redraws the `⏺ Bash(...)` tool-call row so the shell
command is run through Claude Code's own syntax highlighter instead of being
printed as flat, single-colour text.

When the transcript draws a Bash tool call, this mod intercepts the
`ui.render` event for the `ToolUse` component, reads the command the model
sent, and renders it with the built-in `Code` element using the `bash`
grammar. Keywords, strings, comments and command names each get their own
colour. The token palette comes from your active theme's highlighter: a
`dark` base uses Monokai, a `dark-ansi` base follows your terminal's 16 ANSI
colours.

Every other tool, and any Bash call without a string command, is left to the
engine's default rendering. Collapsed rows show only the first line plus a
"ctrl+o to expand" hint; expanded rows show the whole command wrapped.

## Use

Load it as a dev mod in Claude Code and approve the "turn on mods" prompt.
Run any Bash command and the command text in the tool row is highlighted.

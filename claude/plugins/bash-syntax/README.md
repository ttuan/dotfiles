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

## Compact mode

`/bash-syntax compact [on | off]` hides tool details, leaving one line per call:
the tool name and its summary. With no argument it flips the current state, and
the choice carries over to later sessions.

```text
 Bash - Run the test suite
 Edit(hooks/register.tsx) +12 -3
```

Bash shows its description, or the start of the command when it has none. Edit
and Write show the path and the lines changed. Output and diffs are hidden.

- Press ctrl+o to see the full call and its output.
- A failed call still shows its error.
- Permission dialogs still show the full command.
- Agent, AskUserQuestion, plan and task tools are left as they are.
- Only the display changes: the model reads the same output, so no tokens are saved.

## Output lines

`/bash-syntax lines <n | max | default>` sets how many lines of Bash, Edit and
Write output a tool row draws, and carries over to later sessions.

- `3` draws three lines, then `… +N lines (ctrl+o to expand)`.
- `max` draws every line.
- `0` draws only the `… +N lines` hint.
- `default` goes back to the engine's own rows.

Compact mode wins: while it is on, no output is drawn. Errors, ctrl+o and other
tools (Read, Grep, MCP tools) keep the engine's rows.

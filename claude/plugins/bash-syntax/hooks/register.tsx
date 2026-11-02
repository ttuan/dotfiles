import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import type { OutputLines } from '../types'

// Tool inputs are `unknown` at ui.render; read fields defensively.
type AnyInput = {
  command?: string
  description?: string
  file_path?: string
  path?: string
  pattern?: string
  glob?: string
}

// Monokai-ish palette, tuned for a dark background. Raw hex so the look is
// predictable; on a light theme these want swapping.
const C = {
  command: '#a6e22e', // first word of a simple command
  keyword: '#f92672', // for/if/while/do/done/...
  string: '#e6db74', // "..." and '...', and Grep patterns
  variable: '#fd971f', // $VAR
  number: '#ae81ff',
  operator: '#f92672',
  flag: '#66d9ef',
  path: '#66d9ef', // file basename, glob pattern
  env: '#8792a2', // NAME=value env prefixes, kept faint so the real command pops
  summary: '#21a691', // the tool's one-line summary / description (stands out)
  added: '#a6e22e', // compact mode: lines a tool added
  removed: '#f92672', // compact mode: lines a tool removed
} as const

// A leading `NAME=value` env-var assignment, e.g. `S=/tmp/x` before a command.
const ENV_ASSIGN = /^[A-Za-z_][A-Za-z0-9_]*=/

type Span = { text: string; color?: string; dim?: boolean }

const KEYWORDS = new Set([
  'if', 'then', 'elif', 'else', 'fi', 'for', 'in', 'do', 'done', 'while',
  'until', 'case', 'esac', 'function', 'select', 'time', 'return',
])
const RESETS_TO_COMMAND = new Set(['do', 'then', 'else'])
const PATH_TOOLS = new Set(['Read', 'Edit', 'MultiEdit', 'Write', 'NotebookEdit'])

// Per-tool Nerd Font glyph shown in place of the generic bullet, coloured by
// call state. Unknown tools fall back to a filled circle (like the native ⏺).
const ICON: Record<string, string> = {
  Bash: '', // terminal
  Read: '', // file
  Edit: '', // pencil
  MultiEdit: '',
  NotebookEdit: '',
  Write: '', // save
  Glob: '', // folder
  Grep: '', // search
}
const DEFAULT_ICON = '' // filled circle

// Compact mode leaves these to the engine: their content is the point of the
// row (a question, a plan, a task list) or already a one-line summary (Agent).
const KEEP_IN_COMPACT = new Set([
  'Agent',
  'AskUserQuestion',
  'EnterPlanMode',
  'ExitPlanMode',
  'TaskCreate',
  'TaskList',
  'TaskUpdate',
  'TodoWrite',
])

// Bash calls without a description fall back to the start of the command.
const FALLBACK_SUMMARY_CHARS = 60

const RULES: { type: string; re: RegExp }[] = [
  { type: 'space', re: /\s+/y },
  { type: 'string', re: /"(?:\\.|[^"\\])*"?|'[^']*'?/y },
  { type: 'variable', re: /\$\{[^}]*\}|\$[A-Za-z_][A-Za-z0-9_]*|\$[0-9]|\$[*@#?$!-]/y },
  { type: 'operator', re: /\|\||&&|>>|<<|[|&;<>(){}]/y },
  { type: 'word', re: /[A-Za-z0-9_./~=+-]+/y },
  { type: 'other', re: /[^\s]/y },
]

function tokenizeLine(line: string): Span[] {
  const spans: Span[] = []
  let i = 0
  let expectCommand = true
  let prevWasSpaceOrOp = true

  while (i < line.length) {
    if (line[i] === '#' && prevWasSpaceOrOp) {
      spans.push({ text: line.slice(i), dim: true })
      break
    }
    let matched = false
    for (const rule of RULES) {
      rule.re.lastIndex = i
      const m = rule.re.exec(line)
      if (!m) continue
      const text = m[0]
      i += text.length
      matched = true

      if (rule.type === 'space') {
        spans.push({ text })
        prevWasSpaceOrOp = true
      } else if (rule.type === 'string') {
        spans.push({ text, color: C.string })
        expectCommand = false
        prevWasSpaceOrOp = false
      } else if (rule.type === 'variable') {
        spans.push({ text, color: C.variable })
        expectCommand = false
        prevWasSpaceOrOp = false
      } else if (rule.type === 'operator') {
        spans.push({ text, color: C.operator })
        expectCommand = true
        prevWasSpaceOrOp = true
      } else if (rule.type === 'word') {
        if (KEYWORDS.has(text)) {
          spans.push({ text, color: C.keyword })
          expectCommand = RESETS_TO_COMMAND.has(text)
        } else if (expectCommand && ENV_ASSIGN.test(text)) {
          // `NAME=value` prefix: faint, and still at command position so the
          // actual command after it keeps its own colour.
          spans.push({ text, color: C.env })
        } else if (expectCommand) {
          spans.push({ text, color: C.command })
          expectCommand = false
        } else if (text.startsWith('-')) {
          spans.push({ text, color: C.flag })
        } else if (/^\d+$/.test(text)) {
          spans.push({ text, color: C.number })
        } else {
          spans.push({ text })
        }
        prevWasSpaceOrOp = false
      } else {
        spans.push({ text })
        prevWasSpaceOrOp = false
      }
      break
    }
    if (!matched) {
      spans.push({ text: line[i] ?? '' })
      i += 1
    }
  }
  return spans.length > 0 ? spans : [{ text: '' }]
}

function pathSpans(p: string): Span[] {
  const i = p.lastIndexOf('/')
  if (i < 0) return [{ text: p, color: C.path }]
  return [{ text: p.slice(0, i + 1), dim: true }, { text: p.slice(i + 1), color: C.path }]
}

// A file or a stream ending in a newline has no empty line after it.
const toLines = (text: string) => text.replace(/\n+$/, '').split('\n')

// Bash output can carry colour codes, which a Text would print as they are.
const ANSI = /\x1b\[[0-9;]*[A-Za-z]/g

type AnyOutput = {
  stdout?: string
  stderr?: string
  interrupted?: boolean
  type?: string
  content?: string
  structuredPatch?: { lines?: string[] }[]
}

// What a tool's result reads as, line by line; undefined leaves it to the
// engine: the tools whose output this mod does not know, and an empty result.
function resultSpans(tool: string, output: unknown): Span[] | undefined {
  const o = output as AnyOutput | undefined
  if (tool === 'Bash') {
    if (typeof o?.stdout !== 'string' || o.interrupted) return undefined
    const text = [o.stdout, o.stderr ?? ''].filter(part => part.length > 0).join('\n')
    if (text.trim().length === 0) return undefined
    return toLines(text.replace(ANSI, '')).map(text => ({ text }))
  }
  if (tool === 'Write' && o?.type === 'create' && typeof o.content === 'string') {
    return toLines(o.content).map(text => ({ text }))
  }
  if ((tool === 'Edit' || tool === 'Write') && Array.isArray(o?.structuredPatch)) {
    const lines = o.structuredPatch.flatMap(hunk => hunk.lines ?? [])
    if (lines.length === 0) return undefined
    return lines.map(text => ({
      text,
      color: text.startsWith('+') ? C.added : text.startsWith('-') ? C.removed : undefined,
    }))
  }
  return undefined
}

function parseOutputLines(arg: string | undefined): OutputLines | undefined {
  if (arg === 'max') return 'max'
  if (arg === 'default') return null
  return arg !== undefined && /^\d+$/.test(arg) ? Number(arg) : undefined
}

const isOutputLines = (value: unknown): value is OutputLines =>
  value === null || value === 'max' || (typeof value === 'number' && value >= 0)

function firstLine(text: string): string {
  const line = text.trimStart().split('\n')[0] ?? ''
  return line.length > FALLBACK_SUMMARY_CHARS
    ? `${line.slice(0, FALLBACK_SUMMARY_CHARS)}…`
    : line
}

// `+12 -3` for an Edit, from the patch the tool stored; `+N` for a new file.
// Output is `unknown` at ui.render, and absent while the call runs.
function changeSpans(output: unknown): Span[] {
  const o = output as
    | { type?: string; content?: string; structuredPatch?: { lines?: string[] }[] }
    | undefined
  let added = 0
  let removed = 0
  if (o?.type === 'create' && typeof o.content === 'string') {
    added = toLines(o.content).length
  } else if (Array.isArray(o?.structuredPatch)) {
    for (const line of o.structuredPatch.flatMap(hunk => hunk.lines ?? [])) {
      if (line.startsWith('+')) added += 1
      else if (line.startsWith('-')) removed += 1
    }
  }
  const spans: Span[] = []
  if (added > 0) spans.push({ text: ` +${added}`, color: C.added })
  if (removed > 0) spans.push({ text: ` -${removed}`, color: C.removed })
  return spans
}

// Compact mode lives in $.state so a row that read it redraws when it flips,
// and in $.store so it carries over to the next session.
const compact = atom({ plugin: 'bash-syntax', key: 'compact' } as const, false)

// How many lines of a tool's output to draw: a count, 'max', or null for the
// engine's own rows. Compact mode wins: it draws none.
const outputLines = atom(
  { plugin: 'bash-syntax', key: 'outputLines' } as const,
  null as OutputLines,
)

// Read the toggle and length cap from settings; refreshed on each reload.
let enabled = true
let maxChars = 2000

export const register: Register = (on, options) => {
  if (typeof options.enabled === 'boolean') enabled = options.enabled
  if (typeof options.maxChars === 'number' && options.maxChars > 0) {
    maxChars = options.maxChars
  }

  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'bash-syntax',
      description:
        'Toggle tool-row colouring (on | off), hide tool details (compact [on | off]), or limit tool output (lines <n> | max | default)',
    })
    const stored = await $.store.get('compact')
    if (typeof stored === 'boolean') await update($, compact, () => stored)
    const storedLines = await $.store.get('outputLines')
    if (isOutputLines(storedLines)) await update($, outputLines, () => storedLines)
    return next(e)
  })

  on('command.run', { command: 'bash-syntax' }, async ($, e) => {
    const [arg, compactArg] = e.args.trim().toLowerCase().split(/\s+/)
    if (arg === 'compact') {
      const value =
        compactArg === 'on' ? true : compactArg === 'off' ? false : !(await read($, compact))
      await update($, compact, () => value)
      await $.store.set('compact', value)
      return { text: `compact tool rows are now ${value ? 'ON' : 'OFF'}` }
    }
    if (arg === 'lines') {
      const value = parseOutputLines(compactArg)
      if (value === undefined) {
        const current = await read($, outputLines)
        return {
          text: `tool output lines: ${current ?? 'default'}. Set it with /bash-syntax lines <n> | max | default`,
        }
      }
      await update($, outputLines, () => value)
      await $.store.set('outputLines', value)
      return { text: `tool output lines are now ${value ?? 'default'}` }
    }
    enabled = arg === 'on' ? true : arg === 'off' ? false : !enabled
    $.ui.invalidate('ui.render')
    return { text: `tool-row syntax colouring is now ${enabled ? 'ON' : 'OFF'}` }
  })

  on('ui.render', { component: 'ToolUse' }, async ($, e, next) => {
    const tool = e.props.tool
    // ctrl+o (isExpanded) always shows everything.
    const isCompact =
      !e.props.isExpanded && !KEEP_IN_COMPACT.has(tool) && (await read($, compact))
    if (!enabled && !isCompact) return next(e)
    const input = e.props.input as AnyInput | undefined
    if (!input) return next(e)

    const { Box, Text } = $.ui.resolve(e)

    const bullet = e.props.isErrored
      ? 'error'
      : e.props.isInterrupted
        ? 'warning'
        : e.props.isRunning
          ? 'claude'
          : 'success'
    const icon = ICON[tool] ?? DEFAULT_ICON

    const drawSpans = (spans: Span[], keyPrefix: string, italic = false) =>
      spans.map((s, si) => (
        <Text key={`${keyPrefix}${si}`} color={s.color} dimColor={s.dim} italic={italic}>
          {s.text}
        </Text>
      ))

    // One-line header: ⏺ Name - summary
    const summaryRow = (summary?: string) => (
      <Text wrap={isCompact ? 'truncate-end' : 'wrap'}>
        <Text color={bullet}>{icon} </Text>
        <Text bold italic>{tool}</Text>
        {summary ? (
          <Text color={C.summary} italic>{' - '}{summary}</Text>
        ) : null}
      </Text>
    )

    // One-line header: ⏺ Name(<coloured arg>)<after>
    // One Text, so a long path wraps as a line and not column by column.
    const inlineRow = (extra: Span[], after: Span[] = []) => (
      <Text wrap={isCompact ? 'truncate-middle' : 'wrap'}>
        <Text color={bullet}>{icon} </Text>
        <Text bold italic>{tool}</Text>
        <Text italic>(</Text>
        {drawSpans(extra, 'a', true)}
        <Text italic>)</Text>
        {drawSpans(after, 'c')}
      </Text>
    )

    // --- Bash: full shell tokenising, multi-line aware ---
    if (tool === 'Bash') {
      const command = input.command
      if (typeof command !== 'string' || command.trim().length === 0) {
        return next(e)
      }
      if (isCompact) return summaryRow(input.description?.trim() || firstLine(command))
      if (command.length > maxChars) return next(e) // safety cap

      const lines = command.split('\n')
      const expanded = e.props.isExpanded ?? false
      const visible = expanded ? lines : lines.slice(0, 1)
      const hidden = expanded ? 0 : lines.length - 1

      return (
        <Box flexDirection="column">
          {summaryRow(input.description)}
          <Box marginLeft={2} flexDirection="column">
            {visible.map((line, li) => (
              <Text key={`l${li}`} wrap={expanded ? 'wrap' : 'truncate-end'}>
                {drawSpans(tokenizeLine(line), `s${li}_`)}
              </Text>
            ))}
            {hidden > 0 ? (
              <Text dimColor>… +{hidden} lines (ctrl+o to expand)</Text>
            ) : null}
          </Box>
        </Box>
      )
    }

    // --- Path tools: colour the file path ---
    if (PATH_TOOLS.has(tool)) {
      const fp = input.file_path ?? input.path
      if (typeof fp !== 'string' || fp.length === 0 || fp.length > maxChars) {
        return next(e)
      }
      return inlineRow(pathSpans(fp), isCompact ? changeSpans(e.props.output) : [])
    }

    // --- Glob: colour the glob pattern, dim the search path ---
    if (tool === 'Glob') {
      const pat = input.pattern
      if (typeof pat !== 'string' || pat.length === 0) return next(e)
      const extra: Span[] = [{ text: pat, color: C.path }]
      if (input.path) extra.push({ text: ` in ${input.path}`, dim: true })
      return inlineRow(extra)
    }

    // --- Grep: colour the regex, dim path/glob scope ---
    if (tool === 'Grep') {
      const pat = input.pattern
      if (typeof pat !== 'string' || pat.length === 0) return next(e)
      const extra: Span[] = [{ text: pat, color: C.string }]
      if (input.glob) extra.push({ text: ` ${input.glob}`, dim: true })
      else if (input.path) extra.push({ text: ` in ${input.path}`, dim: true })
      return inlineRow(extra)
    }

    if (isCompact) return summaryRow(input.description?.trim())
    return next(e)
  }).catch(($, e, next) => next(e))

  // The body under a tool row: Edit's diff, Write's content, Bash's stdout.
  // A failed call keeps its error, or it would look like a success.
  on('ui.render', { component: 'ToolResult' }, async ($, e, next) => {
    const { tool, isErrored, isExpanded } = e.props
    if (isExpanded || isErrored || KEEP_IN_COMPACT.has(tool)) return next(e)
    const { Box, Text } = $.ui.resolve(e)
    if (await read($, compact)) return <Box display="none" />

    const limit = await read($, outputLines)
    if (limit === null) return next(e)
    const spans = resultSpans(tool, e.props.output)
    if (!spans) return next(e)

    const shown = limit === 'max' ? spans : spans.slice(0, limit)
    const hidden = spans.length - shown.length
    const rows: Span[] =
      hidden > 0
        ? [...shown, { text: `… +${hidden} lines (ctrl+o to expand)`, dim: true }]
        : shown
    return (
      <Box flexDirection="column">
        {rows.map((row, ri) => (
          <Box>
            <Text dimColor>{ri === 0 ? '  ⎿  ' : '     '}</Text>
            <Text color={row.color} dimColor={row.dim}>{row.text || ' '}</Text>
          </Box>
        ))}
      </Box>
    )
  }).catch(($, e, next) => next(e))
}

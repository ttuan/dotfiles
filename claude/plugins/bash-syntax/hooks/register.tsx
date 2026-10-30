import type { Register } from 'claude-code'

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
      description: 'Toggle tool-row syntax colouring (on | off)',
    })
    return next(e)
  })

  on('command.run', { command: 'bash-syntax' }, ($, e) => {
    const arg = e.args.trim().toLowerCase()
    enabled = arg === 'on' ? true : arg === 'off' ? false : !enabled
    return { text: `tool-row syntax colouring is now ${enabled ? 'ON' : 'OFF'}` }
  })

  on('ui.render', { component: 'ToolUse' }, ($, e, next) => {
    if (!enabled) return next(e)
    const tool = e.props.tool
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

    // One-line header: ⏺ Name(<coloured arg>)
    const inlineRow = (extra: Span[]) => (
      <Box>
        <Text color={bullet}>{icon} </Text>
        <Text bold italic>{tool}</Text>
        <Text italic>(</Text>
        {drawSpans(extra, 'a', true)}
        <Text italic>)</Text>
      </Box>
    )

    // --- Bash: full shell tokenising, multi-line aware ---
    if (tool === 'Bash') {
      const command = input.command
      if (typeof command !== 'string' || command.trim().length === 0) {
        return next(e)
      }
      if (command.length > maxChars) return next(e) // safety cap

      const lines = command.split('\n')
      const expanded = e.props.isExpanded ?? false
      const visible = expanded ? lines : lines.slice(0, 1)
      const hidden = expanded ? 0 : lines.length - 1

      return (
        <Box flexDirection="column">
          <Box>
            <Text color={bullet}>{icon} </Text>
            <Text bold italic>Bash</Text>
            {input.description ? (
              <Text color={C.summary} italic>{' - '}{input.description}</Text>
            ) : null}
          </Box>
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
      return inlineRow(pathSpans(fp))
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

    return next(e)
  }).catch(($, e, next) => next(e))
}

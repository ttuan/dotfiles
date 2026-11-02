export type CompactMode = boolean

/** A count, every line, or null for the engine's own rows. */
export type OutputLines = number | 'max' | null

declare module 'claude-code' {
  interface PluginState {
    'bash-syntax': { compact: CompactMode; outputLines: OutputLines }
  }
}

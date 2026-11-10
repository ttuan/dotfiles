return {
  "obsidian-nvim/obsidian.nvim", -- community fork of the archived epwalsh/obsidian.nvim
  version = "*",
  lazy = true,
  ft = "markdown", -- Auto load this plugin for markdown files
  opts = {
    legacy_commands = false, -- new `:Obsidian <subcommand>` form instead of `:ObsidianToday` etc.
    workspaces = {
      {
        name = "personal",
        path = vim.fn.expand("~/code/brain/content"),
      },
    },
  },
}

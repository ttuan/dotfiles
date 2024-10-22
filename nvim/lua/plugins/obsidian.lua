return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown", -- Auto load this plugin for markdown files
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = vim.fn.expand("~") .. "/Dropbox/Apps/Obsidian/brain/content",
      },
    },
  },
}

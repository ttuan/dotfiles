return {
  {
    "morhetz/gruvbox",
    lazy = true,
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "warmer",
      })
    end,
  },
  -- {
  --   "AlexvZyl/nordic.nvim",
  --   lazy = true,
  --   priority = 1000,
  -- },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },

  -- Bundled by LazyVim itself, so they cannot simply be commented out: disable them
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
}

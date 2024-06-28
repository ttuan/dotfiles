return {
  -- Tracking coding time
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        panel = { enabled = true },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gr", false }
    end,
  },

  -- Rails
  {
    "tpope/vim-rails",
    config = function()
      -- Custom autocommand to set YAML filetype correctly
      vim.cmd([[
              augroup MyYamlOverrides
                autocmd!
                autocmd BufRead,BufNewFile *.yml,*.yaml set filetype=yaml
              augroup END
            ]])
    end,
  },
  {
    "slim-template/vim-slim",
    lazy = false,
  },
  {
    "vim-test/vim-test",
    cmd = { "TestFile", "TestNearest", "TestLast" },
    config = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "30"

      vim.g["test#preserve_screen"] = false
      vim.g.neomake_open_list = true
      vim.g["test#strategy"] = {
        nearest = "vimux",
        file = "vimux",
        suite = "vimux",
      }
      vim.g["test#python#pytest#options"] = "--disable-warnings -s"
      vim.g["test#neovim#term_position"] = "vert"
      vim.g.neomake_warning_sign = {
        text = "∙",
      }
      vim.g.neomake_error_sign = {
        text = "∙",
      }
    end,
    keys = {
      {
        "<Leader>rt",
        "<cmd>TestNearest<cr>",
        silent = true,
        desc = "Run test nearest",
      },
      {
        "<Leader>rs",
        "<cmd>TestFile<cr>",
        silent = true,
        desc = "Run test file",
      },
      {
        "<Leader>rl",
        "<cmd>TestLast<cr>",
        silent = true,
        desc = "Run last test",
      },
    },
  },

  { "ttuan/my-vim-snippets" },
}

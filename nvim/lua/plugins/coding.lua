return {
  -- Tracking coding time
  {
    "wakatime/vim-wakatime",
    lazy = false,
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

  --- Reconfig nvim-cmp to use copilot suggestion Super Tab
  --   {
  --     "hrsh7th/nvim-cmp",
  --     dependencies = {
  --       "hrsh7th/cmp-emoji",
  --     },
  --     ---@param opts cmp.ConfigSchema
  --     opts = function(_, opts)
  --       local has_words_before = function()
  --         unpack = unpack or table.unpack
  --         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  --       end
  --
  --       local cmp = require("cmp")
  --
  --       opts.mapping = vim.tbl_extend("force", opts.mapping, {
  -- ["<Tab>"] = cmp.mapping(function(fallback)
  --   if require("copilot.suggestion").is_visible() then
  --     require("copilot.suggestion").accept()
  --   elseif cmp.visible() then
  --     cmp.select_next_item()
  --   elseif vim.snippet.active({ direction = 1 }) then
  --     vim.schedule(function()
  --       vim.snippet.jump(1)
  --     end)
  --   elseif has_words_before() then
  --     cmp.complete()
  --   else
  --     fallback()
  --   end
  -- end, { "i", "s" }),
  --         ["<S-Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_prev_item()
  --           elseif vim.snippet.active({ direction = -1 }) then
  --             vim.schedule(function()
  --               vim.snippet.jump(-1)
  --             end)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --       })
  --     end,
  --   },
}

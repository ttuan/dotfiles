return {
  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     terminal = {
  --       win = {
  --         position = "float",
  --       },
  --     },
  --   },
  -- },

  -- Custom motion
  { { "tpope/vim-surround", event = "VeryLazy" } },
  {
    {
      "vim-scripts/ReplaceWithRegister",
      event = "VeryLazy",
      vscode = true,
      config = function()
        vim.api.nvim_set_keymap("n", "gr", "<Plug>ReplaceWithRegisterOperator", { noremap = false, silent = true })
      end,
    },
  },

  -- Others
  {
    enabled = false,
    "folke/flash.nvim",
  },
  {
    -- Maintained fork of the archived Pocco81/auto-save.nvim. It already skips
    -- nomodifiable buffers and prints no "saved" message, so only the
    -- claudecode exclusions are needed. (The old spec set both `config` and
    -- `opts`, and `config` ignored `opts`, so these exclusions never applied.)
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      condition = function(buf)
        -- Special buffers (claudecode diff buffers use "acwrite")
        if vim.bo[buf].buftype ~= "" then
          return false
        end

        -- claudecode diff buffers, by name
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("%(proposed%)") or bufname:match("%(NEW FILE %- proposed%)") or bufname:match("%(New%)") then
          return false
        end

        -- claudecode diff buffers, by the buffer variables it sets
        if
          vim.b[buf].claudecode_diff_tab_name
          or vim.b[buf].claudecode_diff_new_win
          or vim.b[buf].claudecode_diff_target_win
        then
          return false
        end

        return true
      end,
    },
  },
  {
    { "tpope/vim-repeat", event = "VeryLazy" },
  },
  {
    {
      "voldikss/vim-translator",
      config = function()
        vim.g.translator_target_lang = "en"
        vim.g.translator_default_engines = { "google" }
      end,
      keys = {
        {
          "<Leader>t",
          "<Plug>TranslateWV",
          mode = "v",
          desc = "Translate word visually",
          silent = true,
        },
      },
    },
  },
  {
    "benmills/vimux",
    lazy = false,
    config = function()
      vim.g.VimuxUseNearestPane = 1
    end,
    keys = {
      {
        "<Leader>rr",
        function()
          vim.fn.VimuxRunCommand("clear; ruby " .. vim.fn.bufname("%"))
        end,
        desc = "Run Ruby file in Vimux",
        silent = true,
      },
      {
        "<Leader>rp",
        function()
          vim.fn.VimuxRunCommand("clear; python " .. vim.fn.bufname("%"))
        end,
        desc = "Run Python file in Vimux",
        silent = true,
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false, -- Load immediately, not on demand
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "smoka7/hop.nvim", -- maintained fork of the archived phaazon/hop.nvim
    version = "*",
    vscode = true,
    config = function()
      require("hop").setup({ keys = "asdfghjklqwertyuiopzxcvbnm" })
    end,
    keys = {
      {
        "<leader>j",
        function()
          require("hop").hint_words()
        end,
        desc = "Go to word",
      },
      {
        "<leader>l",
        function()
          local directions = require("hop.hint").HintDirection
          require("hop").hint_words({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        desc = "Go char current line",
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "-", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    opts = {
      window = {
        -- position = "float",
        mappings = {
          ["/"] = "none",
        },
      },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    vscode = true,
    opts = {
      keymaps = {
        -- Open blame window
        blame = "<Leader>gb",
        -- Open file/folder in git repository
        browse = "<Leader>go",
        -- Open blame commit
        blame_commit = "<CR>",
        -- Opens a new diff that compares against the current index
        diff = "<Leader>gd",
        -- Close git diff
        diff_close = "<Leader>gD",
      },
    },
  },

  -- Telescope
  -- Reference: https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/lua/plugins/editor.lua
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<C-p>",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
            theme = "dropdown",
            previewer = false,
          })
        end,
        desc = "Lists files in your current working directory, respects .gitignore",
      },
      {
        "<Leader>fs",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Lists Function names, variables, from Treesitter",
      },
      {
        "<Leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      {
        "<Leader>f;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        "sf",
        function()
          local telescope = require("telescope")

          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "center",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              -- your custom normal mode mappings
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}

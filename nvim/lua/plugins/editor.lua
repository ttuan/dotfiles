return {
  -- Custom motion
  { { "tpope/vim-surround", event = "VeryLazy" } },
  {
    {
      "vim-scripts/ReplaceWithRegister",
      event = "VeryLazy",
      config = function()
        vim.api.nvim_set_keymap("n", "gr", "<Plug>ReplaceWithRegisterOperator", { noremap = false, silent = true })
      end,
    },
  },

  -- Custom text object
  { { "machakann/vim-textobj-delimited", event = "VeryLazy" } },

  -- Others
  {
    enabled = false,
    "folke/flash.nvim",
  },
  {
    "907th/vim-auto-save",
    config = function()
      vim.g.auto_save = 1
      vim.g.auto_save_silent = 1
      vim.g.auto_save_in_insert_mode = 1
    end,
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
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
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
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
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

  -- Override nvim-cmp keymaps
  {
    "nvim-cmp",
    keys = {
      -- disable the keymaps default
      { "<Tab>", false },
      { "<S-Tab>", false },
      -- Reconfig it to new keymaps
      {
        "<C-n>",
        function()
          return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<C-p>",
        function()
          return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },

  {
    "telescope.nvim",
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
        "<C-;>",
        ":Telescope live_grep cwd=",
        desc = "Live grep in specific folder",
      },
      -- {
      --   ";f",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.buffers()
      --   end,
      --   desc = "Lists open buffers",
      -- },
      -- {
      --   ";r",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.live_grep({
      --       additional_args = { "--hidden" },
      --     })
      --   end,
      --   desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      -- },
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
      -- {
      --   ";t",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.tags()
      --   end,
      --   desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
      -- },
      -- {
      --   ";;",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.resume()
      --   end,
      --   desc = "Resume the previous telescope picker",
      -- },
      -- {
      --   ";e",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.diagnostics()
      --   end,
      --   desc = "Lists Diagnostics for all open buffers or a specific buffer",
      -- },
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

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
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

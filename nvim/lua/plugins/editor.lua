return {
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
      { "<leader><leader>", false },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>e",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            -- no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Lists files in your current working directory",
      },
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
}

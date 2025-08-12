return {
  -- Tracking coding time
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- Claude Code
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
  },

  -- -- Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup({
  --       panel = { enabled = true },
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = true,
  --         keymap = {
  --           accept = "<Tab>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  --
  -- Rails
  {
    "tpope/vim-rails",
    lazy = false,
    vscode = true,
    config = function()
      -- Custom autocommand to set YAML filetype correctly
      vim.cmd([[
              augroup MyYamlOverrides
                autocmd!
                autocmd BufRead,BufNewFile *.yml,*.yaml set filetype=yaml
              augroup END
            ]])
    end,
    keys = {
      { "<leader>ec", ":Econtroller ", desc = "Rails Edit Controller", noremap = true },
      { "<leader>em", ":Emodel ", desc = "Rails Edit Model", noremap = true },
    },
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

  -- Frontend
  {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup()
    end,
  },

  --   {
  --     "CopilotC-Nvim/CopilotChat.nvim",
  --     opts = {
  --       debug = false, -- Enable debugging
  --       show_help = true, -- Show help actions
  --       window = {
  --         layout = "float",
  --       },
  --       auto_follow_cursor = false, -- Don't follow the cursor after getting response
  --     },
  --     config = function(_, opts)
  --       local chat = require("CopilotChat")
  --       local select = require("CopilotChat.select")
  --       local prompts = {
  --         -- Code related prompts
  --         Refactor = "Please refactor the following code to improve its clarity and readability.",
  --         FixError = "Please explain the error in the following text and provide a solution.",
  --         BetterNamings = "Please provide better names for the following variables and functions.",
  --         -- SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  --         -- SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  --         --
  --         -- Text related prompts
  --         Summarize = "Please summarize the following text.",
  --         Spelling = "Please correct any grammar and spelling errors in the following text.",
  --         Wording = "Please improve the grammar and wording of the following text.",
  --         Concise = "Please rewrite the following text to make it more concise.",
  --       }
  --
  --       -- Use unnamed register for the selection
  --       opts.selection = select.unnamed
  --       opts.prompts = prompts
  --
  --       -- Override the git prompts message
  --       opts.prompts.Commit = {
  --         prompt = "Write commit message for the change with commitizen convention. Output should has format `gcm <message>`",
  --         selection = select.gitdiff,
  --       }
  --       opts.prompts.CommitStaged = {
  --         prompt = "Write commit message for the change with commitizen convention. Output should has format `gcm <message>`",
  --         selection = function(source)
  --           return select.gitdiff(source, true)
  --         end,
  --       }
  --
  --       chat.setup(opts)
  --
  --       vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
  --         chat.ask(args.args, { selection = select.visual })
  --       end, { nargs = "*", range = true })
  --
  --       -- Inline chat with Copilot
  --       vim.api.nvim_create_user_command("CopilotChatInline", function(args)
  --         chat.ask(args.args, {
  --           selection = select.visual,
  --           window = {
  --             layout = "float",
  --             relative = "cursor",
  --             width = 1,
  --             height = 0.4,
  --             row = 1,
  --           },
  --         })
  --       end, { nargs = "*", range = true })
  --
  --       -- Restore CopilotChatBuffer
  --       vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
  --         chat.ask(args.args, { selection = select.buffer })
  --       end, { nargs = "*", range = true })
  --     end,
  --     event = "VeryLazy",
  --     keys = {
  --       -- Show help actions with telescope
  --       {
  --         "<leader>ah",
  --         function()
  --           local actions = require("CopilotChat.actions")
  --           require("CopilotChat.integrations.telescope").pick(actions.help_actions())
  --         end,
  --         desc = "CopilotChat - Help actions",
  --       },
  --       -- Code related commands
  --       { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --       { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --       { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  --       { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  --       { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  --       -- Chat with Copilot in visual mode
  --       {
  --         "<leader>av",
  --         ":CopilotChatVisual",
  --         mode = "x",
  --         desc = "CopilotChat - Open in vertical split",
  --       },
  --       {
  --         "<leader>ai",
  --         ":CopilotChatInline<cr>",
  --         mode = "x",
  --         desc = "CopilotChat - Inline chat",
  --       },
  --       -- Generate commit message based on the git diff
  --       {
  --         "<leader>am",
  --         "<cmd>CopilotChatCommit<cr>",
  --         desc = "CopilotChat - Generate commit message for all changes",
  --       },
  --       {
  --         "<leader>aM",
  --         "<cmd>CopilotChatCommitStaged<cr>",
  --         desc = "CopilotChat - Generate commit message for staged changes",
  --       },
  --       -- Debug
  --       { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
  --       -- Fix the issue with diagnostic
  --       { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
  --       -- Clear buffer and chat history
  --       { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
  --       -- Toggle Copilot Chat Vsplit
  --       { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle Vsplit" },
  --     },
  --   },
}

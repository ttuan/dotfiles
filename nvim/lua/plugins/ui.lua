return {
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  {
    "Pocco81/true-zen.nvim",
    keys = function()
      return {
        { "<leader>zz", ":TZAtaraxis<CR>", desc = "Zen Mode" },
        { "<leader>zn", ":TZNarrow<CR>", desc = "Narrow Mode" },
        { "<leader>zf", ":TZFocus<CR>", desc = "Focusing Mode" },
        { "<leader>zm", ":TZMinimalist<CR>", desc = "Minimalizt Mode" },
      }
    end,
    config = function()
      require("true-zen").setup({
        ui = {
          bottom = {
            laststatus = 0,
            ruler = false,
            showmode = false,
            showcmd = false,
            cmdheight = 1,
          },
          top = {
            showtabline = 0,
          },
          left = {
            number = true,
            relativenumber = true,
            signcolumn = "no",
          },
        },
        modes = {
          ataraxis = {
            shade = "dark",
            backdrop = 0,
            minimum_writing_area = {
              width = 40,
              height = 44,
            },
            quit_untoggles = true,
            padding = {
              left = 50,
              right = 50,
              top = 0,
              bottom = 0,
            },
          },
          minimalist = {
            ignored_buf_types = { "nofile" },
            options = {
              number = true,
              relativenumber = true,
              cursorline = false,
              foldcolumn = "0",
              list = false,
            },
          },
        },
        integrations = {
          tmux = true,
        },
      })
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
                tttt               tttt                                                               
              ttt:::t            ttt:::t                                                               
              t:::::t            t:::::t                                                               
              t:::::t            t:::::t                                                               
        ttttttt:::::tttttttttttttt:::::ttttttt    uuuuuu    uuuuuu    aaaaaaaaaaaaa  nnnn  nnnnnnnn    
        t:::::::::::::::::tt:::::::::::::::::t    u::::u    u::::u    a::::::::::::a n:::nn::::::::nn  
        t:::::::::::::::::tt:::::::::::::::::t    u::::u    u::::u    aaaaaaaaa:::::an::::::::::::::nn 
        tttttt:::::::tttttttttttt:::::::tttttt    u::::u    u::::u             a::::ann:::::::::::::::n
              t:::::t            t:::::t          u::::u    u::::u      aaaaaaa:::::a  n:::::nnnn:::::n
              t:::::t            t:::::t          u::::u    u::::u    aa::::::::::::a  n::::n    n::::n
              t:::::t            t:::::t          u::::u    u::::u   a::::aaaa::::::a  n::::n    n::::n
              t:::::t    tttttt  t:::::t    ttttttu:::::uuuu:::::u  a::::a    a:::::a  n::::n    n::::n
              t::::::tttt:::::t  t::::::tttt:::::tu:::::::::::::::uua::::a    a:::::a  n::::n    n::::n
              tt::::::::::::::t  tt::::::::::::::t u:::::::::::::::ua:::::aaaa::::::a  n::::n    n::::n
                tt:::::::::::tt    tt:::::::::::tt  uu::::::::uu:::u a::::::::::aa:::a n::::n    n::::n
                  ttttttttttt        ttttttttttt      uuuuuuuu  uuuu  aaaaaaaaaa  aaaa nnnnnn    nnnnnn
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}

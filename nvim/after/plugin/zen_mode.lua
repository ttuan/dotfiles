local status, zenMode = pcall(require, "zen-mode")
if (not status) then return end

zenMode.setup {
  window = {
    backdrop = 0.75, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    width = 120,
    height = 1,
    options = {
      -- signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    tmux = { enabled = false }, -- disables the tmux statusline
  },
}

vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { silent = true })

map('n', '<leader>rt', ':TestNearest<CR>', { silent = true })
map('n', '<leader>rs', ':TestFile<CR>', { silent = true })
map('n', '<leader>rl', ':TestLast<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '<Leader>g', ':TestVisit<CR>', { silent = true })

local g = vim.g
local v = vim.v

g.VimuxOrientation = "h"
g.VimuxHeight = "30"

g["test#preserve_screen"] = false
g.neomake_open_list = true
g['test#strategy'] = {
  nearest = 'vimux',
  file = 'vimux',
  suite = 'vimux'
}
g['test#python#pytest#options'] = "--disable-warnings -s"
g['test#neovim#term_position'] = 'vert'
g.neomake_warning_sign = {
  text = '∙'
}
g.neomake_error_sign = {
  text = '∙'
}

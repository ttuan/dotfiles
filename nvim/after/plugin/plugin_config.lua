-- ========================================================================
-- Ag
-- ========================================================================
--
-- To ignore search with folder, use option --ignore-dir={dir1,dir2}
map('n', '<leader>/', ':Ag<Space>')

-- Search all files, unrestricted: https://github.com/ggreer/the_silver_searcher/issues/1189#issuecomment-354655155
map('n', '<leader>?', ':Ag -u<Space>')

-- Search in project with word in clipboard
map('n', '<Leader><Leader>d', ':Ag <C-r>"<CR>')

vim.g.ag_working_path_mode = "r"
vim.o.grepprg = "ag"
vim.g.grep_cmd_opts = '--line-numbers --noheading'

-- ========================================================================
-- Fugitive
-- ========================================================================

map('n', '<leader>gs', ':G<CR>', { noremap = true, silent = true })
map('n', '<leader>bl', ':Git blame<CR>', { noremap = true, silent = true })

map('n', '<leader>gc', ':G commit<CR>', { noremap = true, silent = true })
map('n', '<leader>gp', ':G push<CR>', { noremap = true, silent = true })

map('n', '<leader>gf', ':diffget //2<CR>', { noremap = true, silent = true })
map('n', '<leader>gj', ':diffget //3<CR>', { noremap = true, silent = true })


-- ========================================================================
-- Harpoon
-- ========================================================================
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)


-- ========================================================================
-- Hop
-- ========================================================================
require'hop'.setup { keys = 'asdfghjklqwertyuiopzxcvbnm' }

map('n', '<leader>w', ':HopWord<CR>', { noremap=true })
map('n', '<leader>l', ':HopWordCurrentLineAC<CR>', { noremap=true })
map('n', '<leader>h', ':HopWordCurrentLineBC<CR>', { noremap=true })


-- ========================================================================
-- LSP
-- ========================================================================
-- local lsp = require('lsp-zero').preset({})

-- lsp.preset('recommended')

-- lsp.ensure_installed({
-- })

-- local cmp = require('cmp')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
-- 	["<C-Space>"] = cmp.mapping.complete(),
-- })

-- -- cmp_mappings['<Tab>'] = nil
-- -- cmp_mappings['<S-Tab>'] = nil

-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings
-- })

-- lsp.on_attach(function(client, bufnr)
-- 	local opts = {buffer = bufnr, remap = false}

-- 	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
-- 	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
-- 	-- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
-- 	-- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
-- 	-- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
-- 	-- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
-- 	-- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
-- 	-- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
-- 	-- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
-- 	-- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- end)

-- lsp.setup()


-- ========================================================================
-- Telescope
-- ========================================================================
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ft', builtin.tags, {})

vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


-- ========================================================================
-- Treesitter
-- ========================================================================

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "python", "ruby", "javascript", "c", "lua", "vim", "vimdoc", "query" },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- ========================================================================
-- Nvim-Tmux-Navigation
-- ========================================================================
-- require'nvim-tmux-navigation'.setup {
--     disable_when_zoomed = true, -- defaults to false
--     keybindings = {
--         left = "<C-h>",
--         down = "<C-j>",
--         up = "<C-k>",
--         right = "<C-l>",
--         last_active = "<C-\\>",
--         next = "<C-Space>",
--     }
-- }

-- ========================================================================
-- NERDTree
-- ========================================================================

map('n', '-', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
map('n', ']', ':NERDTreeFind<CR>', { noremap = true, silent = true })

vim.g.NERDTreeMinimalMenu = 1
vim.g.NERDTreeIgnore = { '\\.pyc$', '\\~$', '^__pycache__$' }

-- ========================================================================
-- Emmet
-- ========================================================================
map('i', '<C-j>', '<C-y>,')


-- ========================================================================
-- Autosave
-- ========================================================================
require("auto-save").setup {}


-- ========================================================================
-- Gitgutter
-- ========================================================================
vim.g.gitgutter_sign_added = '✚'
vim.g.gitgutter_sign_modified = '⚡'
vim.g.gitgutter_sign_removed = '✖'
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_max_signs = 200


-- ========================================================================
-- Python-mode
-- ========================================================================
-- vim.api.nvim_command('autocmd CompleteDone * pclose')
-- vim.g.pymode_python = 'python3'
-- vim.g.pymode_doc = 0
-- vim.g.pymode_options_max_line_length = 120


-- ========================================================================
-- Vim-test
-- ========================================================================
map('n', '<leader>rt', ':TestNearest APPLICATION_ID=test SERVER_SOFTWARE=Test<CR>', { silent = true })
map('n', '<leader>rs', ':TestFile APPLICATION_ID=test SERVER_SOFTWARE=Test<CR>', { silent = true })
map('n', '<leader>rl', ':TestLast APPLICATION_ID=test SERVER_SOFTWARE=Test<CR>', { silent = true })
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

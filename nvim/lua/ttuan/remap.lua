vim.g.mapleader = " "

-- DRY
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>pv", ":Ex<CR>")
map("n", "<leader>n", ":noh<CR>")
map("n", "<leader>q", ":q<CR>")

-- Swap between the last two files
map('n', '<leader><leader>c', '<c-^>', {})
-- Quickly select text you just pasted
map('n', 'gV', '`[v`]')
-- Remap VIM 0 to first non-blank character
map('n', 'B', '^', {})
map('n', 'E', '$', {})
-- Y to copy to end of line
map('n', 'Y', 'y$', {})

-- Open file in same directory
map('n', ',e', ':e <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', ',t', ':tabe <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', ',s', ':split <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', ',v', ':vsplit <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})

-- Resizing Windows
map('n', '<leader><leader>=', '<C-w>=', {noremap = true})
map('n', '<leader><leader><UP>', '<C-w>_', {noremap = true})
map('n', '<leader><leader><DOWN>', '<C-w>=', {noremap = true})
map('n', '<leader><leader><LEFT>', '<C-w>|', {noremap = true})
map('n', '<leader><leader><RIGHT>', '<C-w>|', {noremap = true})

map('n', '<Leader><Leader>k', '<C-w>+10', { noremap = true })
map('n', '<Leader><Leader>j', '<C-w>-10', { noremap = true })
map('n', '<Leader><Leader>h', '<C-w><10', { noremap = true })
map('n', '<Leader><Leader>l', '<C-w>>10', { noremap = true })

-- Move a line of text using Leader+[jk]
map('n', '<Leader>j', ':<C-u>normal! mz:m+<CR>`z<CR>', { noremap = true })
map('n', '<Leader>k', ':<C-u>normal! mz:m-2<CR>`z<CR>', { noremap = true })
map('v', '<Leader>k', ":m '<-2<CR>gv=gv")
map('v', '<Leader>j', ":m '>+1<CR>gv=gv")

-- Operator with a panel
map('n', '<Leader>t', ':tabnew<CR>', { noremap = true })
map('n', 'H', ':tabprevious<CR>', { noremap = true})
map('n', 'L', ':tabnext<CR>', { noremap = true})

-- Use C-p and C-n for calling command in history
map('c', '<C-p>', '<Up>', { noremap = true })
map('c', '<C-n>', '<Down>', { noremap = true })

map('n', '<Left>', ':echo "no!"<cr>', { noremap = true })
map('n', '<Right>', ':echo "no!"<cr>', { noremap = true })
map('n', '<Up>', ':echo "no!"<cr>', { noremap = true })
map('n', '<Down>', ':echo "no!"<cr>', { noremap = true })

-- Go to next/prev project search result
map('n', '<Leader>>', ':cnext<CR>', { noremap = true })
map('n', '<Leader><', ':cprev<CR>', { noremap = true })

-- Delete all trailing space when saving file
vim.api.nvim_command('autocmd BufWritePre * :%s/\\s\\+$//e')
-- Force save file when I forgot running 'sudo vim file'
vim.api.nvim_command('cmap w!! %!sudo tee > /dev/null %')

-- Copy current file path
-- Just relative path
map('n', '<leader>cp', ':let @+ = expand("%")<CR>', {noremap = true})
-- Full path
map('n', '<leader>cfp', ':let @+ = expand("%:p")<CR>', {noremap = true})
-- Just filename
map('n', '<leader>cf', ':let @+ = expand("%:t")<CR>', {noremap = true})
-- Quick directory change
map('n', '<leader>cd', ':cd %:p:h<CR>', {noremap = true})

-- Quick open nvim file
map('n', '<leader><leader>v', ':e ~/.config/nvim/init.lua<CR>', {noremap = true})

-- Keep cursor at the middle of file when moving
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

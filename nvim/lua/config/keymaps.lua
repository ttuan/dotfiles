-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local discipline = require("ttuan.discipline")
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Split window
keymap.set("n", "ss", ":split<return>", opts)
keymap.set("n", "sv", ":vsplit<return>", opts)

-- New tab
keymap.set("n", "<Leader>t", ":tabnew<CR>", opts)

-- Do not use arrow keys
keymap.set("n", "<Left>", ":echo 'no!'<cr>", opts)
keymap.set("n", "<Right>", ":echo 'no!'<cr>", opts)
keymap.set("n", "<Up>", ":echo 'no!'<cr>", opts)
keymap.set("n", "<Down>", ":echo 'no!'<cr>", opts)

-- Move lines up/down using Leader+[jk]
-- keymap.set("n", "<Leader>j", ":<C-u>normal! mz:m+<CR>`z<CR>", opts)
-- keymap.set("n", "<Leader>k", ":<C-u>normal! mz:m-2<CR>`z<CR>", opts)
keymap.set("v", "<Leader>k", ":m '<-2<CR>gv=gv", opts)
keymap.set("v", "<Leader>j", ":m '>+1<CR>gv=gv", opts)

-- Move cursor to first non-blank character
keymap.set("n", "B", "^", {})
keymap.set("n", "E", "$", {})

-- Y to copy to end of line
keymap.set("n", "Y", "y$", {})

-- Quickly select text you just pasted
keymap.set("n", "gV", "`[v`]")

-- Swap between the last two files
keymap.set("n", "<Leader>n", "<c-^>", {})

-- Open file in same directory
keymap.set("n", ",e", ':e <C-R>=expand("%:p:h") . "/"<CR>', opts)
keymap.set("n", ",t", ':tabe <C-R>=expand("%:p:h") . "/"<CR>', opts)
keymap.set("n", ",s", ':split <C-R>=expand("%:p:h") . "/"<CR>', opts)
keymap.set("n", ",v", ':vsplit <C-R>=expand("%:p:h") . "/"<CR>', opts)

-- Go to next/prev project search result
keymap.set("n", "<Leader>>", ":cnext<CR>", opts)
keymap.set("n", "<Leader><", ":cprev<CR>", opts)

-- Force save file when I forgot running 'sudo vim file'
vim.api.nvim_command("cmap w!! %!sudo tee > /dev/null %")

-- Keep cursor at the middle of file when moving
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Use C-p and C-n for calling command in history
keymap.set("c", "<C-p>", "<Up>", opts)
keymap.set("c", "<C-n>", "<Down>", opts)

-- Copy current file path
-- Just relative path
keymap.set("n", "<leader>cp", ':let @+ = expand("%")<CR>', opts)
-- Full path
-- keymap.set("n", "<leader>cfp", ':let @+ = expand("%:p")<CR>', opts)
-- Just filename
-- keymap.set("n", "<leader>cf", ':let @+ = expand("%:t")<CR>', opts)
-- Quick directory change
-- keymap.set("n", "<leader>cd", ":cd %:p:h<CR>", opts)

-- Resizing Windows
-- keymap.set("n", "<Leader><Leader>k", "<C-w>+10", opts)
-- keymap.set("n", "<Leader><Leader>j", "<C-w>-10", opts)
-- keymap.set("n", "<Leader><Leader>h", "<C-w><10", opts)
-- keymap.set("n", "<Leader><Leader>l", "<C-w>>10", opts)

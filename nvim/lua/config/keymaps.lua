-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local discipline = require("ttuan.discipline")
-- discipline.cowboy()

-- Mapping Custom functions
local functions = require("ttuan.functions")
keymap.set(
  "n",
  "<Leader>of",
  functions.open_current_file,
  vim.tbl_extend("force", opts, { desc = "Open current file in Chrome" })
)
keymap.set(
  "n",
  "<Leader>ogl",
  functions.go_github_line,
  vim.tbl_extend("force", opts, { desc = "Go to current line in Github" })
)
keymap.set(
  "n",
  "<Leader>ogc",
  functions.go_github_commit,
  vim.tbl_extend("force", opts, { desc = "Go to Github with commit hash" })
)
keymap.set("n", "<Leader>D", function()
  local pattern = vim.fn.input("Enter pattern: ")
  functions.global_delete_to_end_of_line(pattern)
end, vim.tbl_extend("force", opts, { desc = "Delete to end of line" }))
keymap.set("n", "<Leader>B", function()
  local pattern = vim.fn.input("Enter pattern: ")
  functions.global_delete_to_first_occurrence(pattern)
end, vim.tbl_extend("force", opts, { desc = "Delete to first occurrence" }))
keymap.set("n", "<Leader>fN", function()
  vim.cmd('exe "e " .. tempname()')
end, vim.tbl_extend("force", opts, { desc = "Edit a temporary file" }))
vim.api.nvim_set_keymap(
  "n",
  "<Leader>fG",
  ":lua require('ttuan.functions').custom_live_grep(vim.fn.input('Grep in folder: ', '', 'dir'), vim.fn.input('File type (e.g., txt, lua): '))<CR>",
  vim.tbl_extend("force", opts, { desc = "Live grep in specified folder and file type" })
)

-- Remap Lazy to Leader+L
vim.api.nvim_set_keymap("n", "<leader>L", ":Lazy<CR>", { noremap = true, silent = true })

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
keymap.set("n", ",e", ':e <C-R>=expand("%:p:h") . "/"<CR>', { noremap = true, silent = false })
keymap.set("n", ",t", ':tabe <C-R>=expand("%:p:h") . "/"<CR>', { noremap = true, silent = false })
keymap.set("n", ",s", ':split <C-R>=expand("%:p:h") . "/"<CR>', { noremap = true, silent = false })
keymap.set("n", ",v", ':vsplit <C-R>=expand("%:p:h") . "/"<CR>', { noremap = true, silent = false })

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

-- Quit file
keymap.set("n", "<Leader>q", ":wq<CR>", opts)

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

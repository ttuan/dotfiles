-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
local set = vim.opt

vim.scriptencoding = "utf-8"
set.encoding = "utf-8"
set.fileencoding = "utf-8"

set.shell = "zsh"
set.mouse = "a"
set.clipboard:append("unnamed", "unnamedplus")
set.history = 10000
set.backspace = { "eol", "start", "indent" }
set.whichwrap:append("<", ">", "h", "l", "[", "]")
set.omnifunc = "syntaxcomplete#Complete"
set.splitright = true
set.splitbelow = true

set.hlsearch = true
set.incsearch = true
set.ignorecase = true

set.nu = true
set.relativenumber = true
set.showcmd = true
set.showmode = true

set.wrap = true
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

set.scrolloff = 8
set.signcolumn = "yes"
set.isfname:append("@-@")
set.termguicolors = true
set.colorcolumn = "80"

set.smartindent = true
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true

-- Use za, zA, zc, zo, zC, zO, zR, zM, zr, zv
set.foldmethod = "manual"
set.foldlevel = 99

set.spelllang = "en_us"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

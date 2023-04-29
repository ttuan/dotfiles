local set = vim.opt

vim.scriptencoding = 'utf-8'
set.encoding = 'utf-8'
set.fileencoding = 'utf-8'

set.guicursor = ""

set.shell = "zsh"
set.mouse = "a"
set.clipboard:append("unnamed", "unnamedplus")
set.history = 10000
set.backspace = {"eol", "start", "indent"}
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

set.wrap = false
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
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Apperance
  use('scrooloose/nerdtree')
  use('morhetz/gruvbox')
  use('vim-airline/vim-airline')
  use('vim-airline/vim-airline-themes')
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})


  -- Searching & Navigating
  use('rking/ag.vim')
  use('ThePrimeagen/harpoon')
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Action
  use('phaazon/hop.nvim')
  use('tpope/vim-commentary')
  use("Pocco81/auto-save.nvim")

  -- Operator
  use('vim-scripts/ReplaceWithRegister')
  use('tpope/vim-surround')
  use('tpope/vim-repeat')

  -- Text Object
  use('michaeljsmith/vim-indent-object')
  use('machakann/vim-textobj-delimited')

  -- Git
  use('tpope/vim-fugitive')
  use('airblade/vim-gitgutter')

  -- Tmux
  use('christoomey/vim-tmux-navigator')
  use('benmills/vimux')

  -- Coding
  use 'neovim/nvim-lspconfig' -- LSP
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  -- use 'glepnir/lspsaga.nvim' -- LSP UIs
  -- use 'L3MON4D3/LuaSnip'

  -- use('python-mode/python-mode')
  -- use('mattn/emmet-vim')
  use('Glench/Vim-Jinja2-Syntax')
  use('tpope/vim-projectionist')
  use('vim-test/vim-test')

  -- Snippets
  use('SirVer/ultisnips')
  use('quangnguyen30192/cmp-nvim-ultisnips')
  use('honza/vim-snippets')
  -- use('ttuan/my-vim-snippets')
end)

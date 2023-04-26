-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
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

  -- Snippets
  use('SirVer/ultisnips')
  use('honza/vim-snippets')
  use('ttuan/my-vim-snippets')


  -- Git
  use('tpope/vim-fugitive')
  use('airblade/vim-gitgutter')


  -- Tmux
  use('alexghergh/nvim-tmux-navigation')
  use('benmills/vimux')


  -- Coding
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {                                      -- Optional
		  'williamboman/mason.nvim',
		  run = function()
			  pcall(vim.cmd, 'MasonUpdate')
		  end,
		  },
		  {'williamboman/mason-lspconfig.nvim'}, -- Optional

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},     -- Required
		  {'hrsh7th/cmp-nvim-lsp'}, -- Required
		  {'L3MON4D3/LuaSnip'},     -- Required
          }
  }
  use('python-mode/python-mode')
  use('lepture/vim-jinja')
  use('tpope/vim-projectionist')
  use('mattn/emmet-vim')
  use('vim-test/vim-test')
end)

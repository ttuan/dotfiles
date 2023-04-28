require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = {},
  },

  ensure_installed = {
		"python",
		"ruby",
		"javascript",
		"lua",
		"vim"
	},
  autotag = {
    enable = true,
  },

  sync_install = false,
  auto_install = true,
}

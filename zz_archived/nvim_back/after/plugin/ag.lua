-- To ignore search with folder, use option --ignore-dir={dir1,dir2}
map('n', '<leader>/', ':Ag<Space>')

-- Search all files, unrestricted: https://github.com/ggreer/the_silver_searcher/issues/1189#issuecomment-354655155
map('n', '<leader>?', ':Ag -u<Space>')

-- Search in project with word in clipboard
map('n', '<Leader><Leader>d', ':Ag <C-r>"<CR>')

vim.g.ag_working_path_mode = "r"
vim.o.grepprg = "ag"
vim.g.grep_cmd_opts = '--line-numbers --noheading'

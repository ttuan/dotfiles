map('n', '<leader>gs', ':G<CR>', { noremap = true, silent = true })
map('n', '<leader>bl', ':Git blame<CR>', { noremap = true, silent = true })

map('n', '<leader>gc', ':G commit<CR>', { noremap = true, silent = true })
map('n', '<leader>gp', ':G push<CR>', { noremap = true, silent = true })

map('n', '<leader>gf', ':diffget //2<CR>', { noremap = true, silent = true })
map('n', '<leader>gj', ':diffget //3<CR>', { noremap = true, silent = true })

-- Git Gutter
vim.g.gitgutter_sign_added = '✚'
vim.g.gitgutter_sign_modified = '⚡'
vim.g.gitgutter_sign_removed = '✖'
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_max_signs = 200

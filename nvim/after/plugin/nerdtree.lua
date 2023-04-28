map('n', '-', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
map('n', ']', ':NERDTreeFind<CR>', { noremap = true, silent = true })

vim.g.NERDTreeMinimalMenu = 1
vim.g.NERDTreeIgnore = { '\\.pyc$', '\\~$', '^__pycache__$' }

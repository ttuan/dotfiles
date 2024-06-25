require'hop'.setup { keys = 'asdfghjklqwertyuiopzxcvbnm' }

map('n', '<leader>w', ':HopWord<CR>', { noremap=true })
map('n', '<leader>l', ':HopWordCurrentLineAC<CR>', { noremap=true })
map('n', '<leader>h', ':HopWordCurrentLineBC<CR>', { noremap=true })

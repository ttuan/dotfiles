-- Open current file on google chrome
function OpenCurrentFile()
  local current_file = vim.fn.expand("%")
  os.execute("open -a 'Google Chrome' " .. current_file)
end
map("n", "<Leader><Leader>of", ":silent! lua OpenCurrentFile()<CR>", {noremap = true})

-- Go to current line in Github
function goGithubLine()
  local current_file = vim.fn.bufname('%')
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd("silent terminal goGithubLine " .. current_file .. " " .. current_line)
  vim.cmd("startinsert")
end
map("n", "<leader><leader>ggl", ":lua goGithubLine()<CR>", {noremap = true, silent = true})

-- Go to Github with commit hash
function goGithubCommit()
  local commit_hash = vim.fn.expand("<cword>")
  vim.cmd("silent terminal goGithubCommit " .. commit_hash)
  vim.cmd("startinsert")
end
map("n", "<leader><leader>ggc", ":lua goGithubCommit()<CR>", {noremap = true, silent = true})


-- Delete to end of line
function GlobalDeleteToEndOfLine(arg)
  -- Use the global command to execute the delete command on all matching lines
  vim.cmd("g/" .. arg .. "/norm nD")
end
map('n', '<Leader><Leader>D', ':lua GlobalDeleteToEndOfLine("')


-- Auto close windows when COMMIT_EDITMSG git file --> Quickly push + rebase with git
function Close_git_message()
  local filename = vim.fn.expand('%')
  if filename == ".git/COMMIT_EDITMSG" then
    vim.cmd('quitall')
  end
end
vim.cmd('autocmd VimEnter * lua Close_git_message()')


-- Rename current file
function RenameFile()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', vim.fn.expand('%'), 'file')
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. new_name)
    vim.cmd('silent !rm ' .. old_name)
    vim.api.nvim_command('redraw!')
  end
end
map('n', '<Leader>rnf', ':lua RenameFile()<CR>', { noremap = true, silent = true })


-- Edit a temporary file
map('n', '<leader><leader>tp', ':exe "e " .. tempname()<cr>', { noremap = true, silent = true })

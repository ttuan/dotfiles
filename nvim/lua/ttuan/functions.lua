local M = {}

-- Open current file on google chrome
function M.open_current_file()
  local current_file = vim.fn.expand("%:p") -- Get the full path of the current file
  local escaped_file = vim.fn.shellescape(current_file)
  local cmd = string.format("open -a 'Google Chrome' %s", escaped_file)

  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to open file in Google Chrome: " .. result, vim.log.levels.ERROR)
  else
    vim.notify("File opened in Google Chrome", vim.log.levels.INFO)
  end
end

-- Go to current line in Github
function M.go_github_line()
  local current_file = vim.fn.bufname("%")
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = string.format("goGithubLine %s %d", current_file, current_line)

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to execute goGithubLine", vim.log.levels.ERROR)
      else
        vim.notify("GitHub line opened successfully", vim.log.levels.INFO)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
  })
end

-- Go to Github with commit hash
function M.go_github_commit()
  local commit_hash = vim.fn.expand("<cword>")
  local cmd = string.format("goGithubCommit %s", commit_hash)

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to execute goGithubCommit", vim.log.levels.ERROR)
      else
        vim.notify("GitHub commit opened successfully", vim.log.levels.INFO)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
  })
end

-- Delete from start of line to the first occurrence of a character
function M.global_delete_to_first_occurrence(arg)
  if not arg or arg == "" then
    vim.notify("Argument cannot be empty", vim.log.levels.ERROR)
    return
  end
  vim.cmd("g/" .. vim.fn.escape(arg, "/") .. [[/s/^.*]] .. arg .. [[//]])
end

-- Delete to end of line
function M.global_delete_to_end_of_line(arg)
  if not arg or arg == "" then
    vim.notify("Argument cannot be empty", vim.log.levels.ERROR)
    return
  end
  vim.cmd("g/" .. vim.fn.escape(arg, "/") .. [[/s/\(.*\)\zs]] .. arg .. [[.*$//]])
end

-- Telescope livegrep with specific folder and file type
function M.custom_live_grep(relative_folder_path, file_type)
  local cwd = vim.fn.getcwd() -- Get the current working directory

  -- Use current directory if no folder_path is provided
  local folder_path = relative_folder_path and (cwd .. "/" .. relative_folder_path) or cwd

  -- Set file type argument to include all files if not specified
  local file_type_arg = ""
  if file_type and file_type ~= "" then
    file_type_arg = "--glob=*." .. file_type
  end

  require("telescope.builtin").live_grep({
    cwd = folder_path,
    additional_args = function()
      return file_type_arg ~= "" and { file_type_arg } or {}
    end,
  })
end

-- Open today notes
function M.open_today_note()
  local vault_path = os.getenv("OBSIDIAN_VAULT_PATH")
  if vault_path == nil or vault_path == "" then
    print("Error: OBSIDIAN_VAULT_PATH is not set.")
    return
  end

  local today = os.date("%Y-%m-%d")
  local note_path = vault_path .. "/10 Journals/11 Daily/" .. today .. ".md"

  local file_exists = vim.fn.filereadable(note_path) == 1

  if not file_exists then
    vim.fn.mkdir(vim.fn.fnamemodify(note_path, ":h"), "p")
    local file = io.open(note_path, "w")
    if file then
      file:close()
    end
    print("Created new daily note for today: " .. note_path)
  end

  vim.cmd("vsplit " .. note_path)

  -- Resize the window to 30% of the total width
  local total_width = vim.o.columns
  local new_width = math.floor(total_width * 0.3)
  vim.cmd("vertical resize " .. new_width)
end

function M.open_current_file_on_http_server()
  local file_path = vim.fn.expand("%:~:.")
  local url_path = file_path:gsub(vim.fn.getcwd() .. "/", "")
  local url = "http://localhost:3000/" .. url_path

  local chrome_command = string.format("open -a 'Google Chrome' '%s'", url)

  vim.fn.jobstart(chrome_command)
end

-- -- Auto close windows when COMMIT_EDITMSG git file --> Quickly push + rebase with git
-- function Close_git_message()
--   local filename = vim.fn.expand("%")
--   if filename == ".git/COMMIT_EDITMSG" then
--     vim.cmd("quitall")
--   end
-- end
-- -- vim.cmd('autocmd VimEnter * lua Close_git_message()')
--
-- -- Rename current file
-- function RenameFile()
--   local old_name = vim.fn.expand("%")
--   local new_name = vim.fn.input("New file name: ", vim.fn.expand("%"), "file")
--   if new_name ~= "" and new_name ~= old_name then
--     vim.cmd("saveas " .. new_name)
--     vim.cmd("silent !rm " .. old_name)
--     vim.api.nvim_command("redraw!")
--   end
-- end
-- map("n", "<Leader>rnf", ":lua RenameFile()<CR>", { noremap = true, silent = true })

return M

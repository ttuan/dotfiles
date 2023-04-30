local dap, dapui = require("dap"), require("dapui")

-- Config dapui
local ui_config =  {
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
      disconnect = "",
    }
  },
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
}
dapui.setup(ui_config)
vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
})

vim.fn.sign_define('DapBreakpointCondition', {
    text = 'ﳁ',
    texthl = 'DiagnosticSignWarn',
})

vim.fn.sign_define("DapBreakpointRejected", {
    text = '',
    texthl = "DiagnosticSignError",
})

vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "DiagnosticSignWarn",
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Config for Python Debug
require('dap-python').setup('/Users/ttuan/.pyenv/shims/python')

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port or '5678'
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      connect_timeout = 10000,
      log_dir = "/tmp",
      log_file = "/tmp/debugpy.log",
      subProcess = true,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = '/Users/ttuan/.pyenv/shims/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

map('n', '<Leader>dd', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true })
map('n', '<Leader>dc', ':lua require"dap".continue()<CR>', { noremap = true })
map('n', '<Leader>do', ':lua require"dap".step_over()<CR>', { noremap = true })

vim.g.rails_projections = {
    ["app/controllers/*_controller.rb"] = {
        test = {
            "spec/controllers/{}_controller_spec.rb",
            "spec/requests/{}_spec.rb"
        }
    },
    ["spec/requests/*_spec.rb"] = {
        alternate = {
            "app/controllers/{}_controller.rb"
        }
    }
}

-- Define key mappings
map('n', '<Leader>em', ':Emodel ', { noremap = true, silent = true })
map('n', '<Leader>ev', ':Eview ', { noremap = true, silent = true })
map('n', '<Leader>ec', ':Econtroller ', { noremap = true, silent = true })
map('n', '<Leader>eh', ':Ehelper ', { noremap = true, silent = true })

-- Set filetype for erb files to yaml, for using treesitter yaml parser
vim.api.nvim_create_autocmd("FileType", {
  pattern = "eruby.yaml",
  command = "set filetype=yaml",
})

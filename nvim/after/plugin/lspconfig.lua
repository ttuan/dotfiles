local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.ConfirmBehavior.Insert }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.ConfirmBehavior.Insert }),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),

  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
    },
    {
      { name = 'buffer' },
    },
    {
      { name = 'path'}
    }
  ),

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      preset = 'codicons',
      symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = ""
      },
    })
  }
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>vsplit | lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.html.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- nvim_lsp.jedi_language_server.setup {
--   on_attach = on_attach,
--   capabilities = capabilities
-- }

-- nvim_lsp.lua_ls.setup {
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
--   on_attach = on_attach,
--   capabilities = capabilities
-- }

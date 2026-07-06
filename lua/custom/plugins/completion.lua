vim.pack.add {
  'https://github.com/Saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
}

local luasnip = require 'luasnip'

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load {
  paths = { vim.fn.stdpath 'config' .. '/snippets' },
}
-- Prefer custom ones over default
luasnip.config.set_config {
  history = true,
  override_priority = 1000,
}

require('blink.cmp').setup {
  keymap = { preset = 'default' },

  completion = {
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
    },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
}

-- local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('svelte', {
  -- capabilities = capabilities,
  cmd_env = {
    CHOKIDAR_IGNORE = '/home/danielle/.var',
  },
  settings = {
    svelte = {
      plugin = {
        svelte = {
          hover = { enable = true },
        },
        typescript = { hover = { enable = true } },
      },
    },
  },
  -- on_attach = function(client, bufnr)
  --   vim.api.nvim_create_autocmd('BufWritePost', {
  --     pattern = { '*.js', '*.ts' },
  --     callback = function(ctx) client.notify('$/onDidChangeTsOrJsFile', { uri = vim.uri_from_bufnr(ctx.buf) }) end,
  --   })
  -- end,
})

local web_servers = { 'ts_ls', 'cssls', 'html', 'tailwindcss', 'svelte' }
vim.lsp.enable(web_servers)

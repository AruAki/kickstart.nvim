vim.pack.add {
  'https://github.com/Saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
}

local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ 
  paths = { vim.fn.stdpath("config") .. "/snippets" } 
})
-- Prefer custom ones over default
luasnip.config.set_config({
  history = true,
  override_priority = 1000,
})

require('blink.cmp').setup {
  keymap = { preset = 'default' },

  completion = {
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
    },
    -- This helps filter out some of the internal snippet noise
    list = { selection = { preselect = true, auto_insert = true } },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
}

-- 3. Modern LSP Setup
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.enable('svelte', {
  capabilities = capabilities,
  settings = {
    svelte = {
      plugin = {
        svelte = {
          -- This is the magic toggle to show cleaner documentation
          hover = { enable = true }
        },
        -- If you hate the internal TS definitions, you can tweak these
        typescript = { hover = { enable = true } },
      }
    }
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_bufnr(ctx.buf) })
      end,
    })
  end,
})

-- Other servers
local web_servers = { 'ts_ls', 'cssls', 'html' }
for _, server in ipairs(web_servers) do
  vim.lsp.enable(server, { capabilities = capabilities })
end

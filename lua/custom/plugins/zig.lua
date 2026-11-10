vim.pack.add {
  { src = 'https://codeberg.org/ziglang/zig.vim' },
}

vim.g.zig_fmt_autosave = 1 -- Format on save

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function(ev) vim.lsp.buf.format() end,
})

vim.lsp.config('zls', {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'build.zig' },
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable 'zls'

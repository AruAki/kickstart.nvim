vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {
  enabled = true,
  latex = { enabled = false },
  completions = {
    lsp = { enabled = true },
    blink = { enabled = true },
  },
}

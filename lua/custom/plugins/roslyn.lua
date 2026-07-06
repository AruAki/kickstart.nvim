vim.pack.add {
  'https://github.com/seblyng/roslyn.nvim',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cs',
  once = true,
  callback = function() require('roslyn').setup {} end,
})

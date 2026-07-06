vim.filetype.add {
  extension = { gd = 'gdscript' },
}

vim.lsp.config('gdscript', {
  cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
  filetypes = { 'gdscript' },
  root_dir = function(bufnr, on_dir) on_dir(vim.fs.root(bufnr, 'project.godot')) end,
})

vim.lsp.enable 'gdscript'

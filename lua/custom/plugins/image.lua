vim.pack.add {
  'https://github.com/3rd/image.nvim',
}

require('image').setup {
  backend = 'kitty',
  processor = 'magick_cli',
  integrations = {
    markdown = {
      enabled = true,
      floating_windows = true,
      filetypes = { 'markdown' },
    },
    svelte = {
      enabled = true,
      clear_in_insert_mode = true,
      only_render_image_at_cursor = true,
      only_render_image_at_cursor_mode = 'inline',
      filetypes = { 'svelte' },
    },
  },
}

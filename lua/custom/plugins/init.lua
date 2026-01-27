-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup() -- Enable auto tag closing
    end,
    ft = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' }, -- Activate for relevant filetypes
    lazy = true, -- Lazy-load the plugin when required
  },
}

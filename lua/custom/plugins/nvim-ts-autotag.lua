-- 1. Install the plugin
vim.pack.add { 'https://github.com/windwp/nvim-ts-autotag' }

-- 2. Configure it
-- We wrap the setup in a protected call (pcall) just in case the 
-- plugin hasn't finished downloading yet on the first run.
local status, autotag = pcall(require, 'nvim-ts-autotag')
if status then
  autotag.setup({
    opts = {
      -- enable_close = true,
      -- enable_rename = true,
      -- enable_close_on_slash = true,
    },
    -- In the new version of autotag, per-filetype enabling is 
    -- often handled automatically, but you can be explicit:
    aliases = {
      ['svelte'] = 'html',
    }
  })
end

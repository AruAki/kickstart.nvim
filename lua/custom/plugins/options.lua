-- NOTE: Write to same file, otherwise Bun hotreload crashes
vim.o.backupcopy = 'yes'

-- NOTE: Set tab size to 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.relativenumber = true

-- NOTE: Delete into the black hole register so it doesn't overwrite clipboard
vim.keymap.set({ 'n', 'v' }, 'd', '"_d')
vim.keymap.set({ 'n', 'v' }, 'dd', '"_dd')
vim.keymap.set({ 'n', 'v' }, 'D', '"_D')
-- NOTE: Do the same for 'x' (delete single character)
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')

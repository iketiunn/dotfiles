vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>th', ':set hlsearch!<CR>', { desc = '[T]oggle [H]ighlight' })

-- TODO: Force tab to be 2 spaces since the indent plugin is not working at upper level
vim.o["shiftwidth"] = 2
vim.o["tabstop"] = 2
vim.o["softtabstop"] = 2
vim.o["expandtab"] = true


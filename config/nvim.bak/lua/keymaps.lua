vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>th', ':set hlsearch!<CR>', { desc = '[T]oggle [H]ighlight' })

-- Ensure vim-sleuth respects these defaults if it can't detect indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript" },
  callback = function()
      vim.b.sleuth_automatic = false
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
  end,
})


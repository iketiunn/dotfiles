-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set('n', '<C-p>', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<C-b>', function() Snacks.explorer.reveal() end, { desc = '[O]pen [E]xplorer' })
vim.keymap.set('n', '<leader><Space>', function() Snacks.picker.buffers() end, { desc = 'Select Buffer' })

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

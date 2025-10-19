-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

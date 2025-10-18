return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    pcall(require('telescope').load_extension, 'file_browser')
    vim.keymap.set('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = '[F]ile [B]rowser' })
  end,
}

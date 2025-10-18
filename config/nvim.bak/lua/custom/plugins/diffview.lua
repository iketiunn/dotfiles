return {
  'sindrets/diffview.nvim',
  config = function ()
    require('diffview').setup({
      use_icons = false
    })
    vim.keymap.set('n', '<leader>gd', function ()
      if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
      else
        vim.cmd('DiffviewClose')
      end
    end, { desc = 'Toggle [G]it [D]iff view' })
  end
}


return {
  'prettier/vim-prettier',
  config = function()
    vim.cmd([[
      let g:prettier#autoformat = 1
      let g:prettier#autoformat_require_pragma = 0
    ]])
  end
}

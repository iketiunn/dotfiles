return {
  'github/copilot.vim',
  config = function()
    vim.g.copilot_assume_mapped = true
    -- `fnm alias default 20`
    -- And get path in "$FNM_DIR/aliases/..."
    vim.g.copilot_node_command ='/Users/ike/Library/Application Support/fnm/aliases/20/bin/node'
  end,
}

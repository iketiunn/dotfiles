return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  config = function()
    vim.g.gitblame_enabled = true
    vim.g.gitblame_set_extmark_options = { virt_text_pos = "eol_right_align" }
    vim.keymap.set("n", "<leader>tb", "<cmd>GitBlameToggle<CR>", { desc = "Toggle Git Blame" })
  end,
}

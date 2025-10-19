return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>t", group = "[T]oggle" },
        { "<leader>y", group = "[Y]ank" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Toggle commands
      wk.add({
        { "<leader>th", ":set hlsearch!<CR>", desc = "[T]oggle [H]ighlight", icon = "🔍" },
      })
      -- Yank commands
      wk.add({
        { "<leader>yp", function()
            local relative_path = vim.fn.expand('%:.')
            vim.fn.setreg('+', relative_path)
            vim.notify('Yanked relative path: ' .. relative_path)
          end, desc = "Yank relative file path", icon = "📄" },
        { "<leader>yP", function()
            local absolute_path = vim.fn.expand('%:p')
            vim.fn.setreg('+', absolute_path)
            vim.notify('Yanked absolute path: ' .. absolute_path)
          end, desc = "Yank absolute file path", icon = "📁" },
      })
    end,
  },
}

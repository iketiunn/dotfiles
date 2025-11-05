return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = function(_, opts)
    -- opts.sections.lualine_c[4] = { "filename", path = 1 }
    opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({
      length = 6,
    }) }
  end,
}
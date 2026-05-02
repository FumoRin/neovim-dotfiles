return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("config.plugins.indent_blankline").setup()
  end,
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("config.plugins.treesitter").setup()
  end,
}

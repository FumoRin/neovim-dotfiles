return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
    require("nvim-treesitter").install(require("config.plugins.treesitter").parsers):wait(300000)
  end,
  lazy = false,
  config = function()
    require("config.plugins.treesitter").setup()
  end,
}

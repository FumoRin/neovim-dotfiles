return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("config.plugins.snacks").setup()
  end,
  keys = {
    {
      "<leader>mi",
      function()
        Snacks.image.hover()
      end,
      desc = "Hover/Preview Image",
    },
  },
}

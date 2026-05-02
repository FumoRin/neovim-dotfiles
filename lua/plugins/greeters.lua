return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("config.plugins.greeters").setup()
  end,
}

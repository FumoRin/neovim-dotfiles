return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.plugins.telescope").setup_core()
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("config.plugins.telescope").setup_ui_select()
    end,
  },
}

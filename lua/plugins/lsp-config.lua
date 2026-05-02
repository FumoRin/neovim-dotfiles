return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("config.plugins.lsp").setup_mason()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    version = "1.29.0",
    config = function()
      require("config.plugins.lsp").setup_mason_lspconfig()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    config = function()
      require("config.plugins.lsp").setup_lspconfig()
    end,
  }
}

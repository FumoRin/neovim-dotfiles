return {
  "ray-x/lsp_signature.nvim",
  event = { "InsertEnter", "LspAttach" },
  config = function()
    require("config.plugins.lsp_signature").setup()
  end,
}

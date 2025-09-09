return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim"
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        source = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          require("none-ls.diagnostics.eslint_d")
        }
      })
      vim.keymap.set('n', '<leader>fa', vim.lsp.buf.format, {})
    end
  }
}

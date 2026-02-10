return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      -- Patch code actions to include full ShellCheck message
      local shellcheck_actions = require("none-ls-shellcheck.code_actions")
      shellcheck_actions._transform = function(actions, params)
        local diags = vim.diagnostic.get(params.bufnr)
        for _, action in ipairs(actions) do
          for _, diag in ipairs(diags) do
            if diag.code == action.title then
              action.title = diag.code .. ": " .. diag.message
            end
          end
        end
        return actions
      end

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          require("none-ls.diagnostics.eslint_d"),

          null_ls.builtins.formatting.shfmt,

          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"), -- patched
        },
      })

      vim.keymap.set("n", "<leader>fa", vim.lsp.buf.format, {})
    end,
  },
}


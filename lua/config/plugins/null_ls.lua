local M = {}

function M.setup()
  local null_ls = require("null-ls")
  local sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.shfmt,
    require("none-ls-shellcheck.diagnostics"),
    require("none-ls-shellcheck.code_actions"),
  }

  if vim.fn.executable("eslint_d") == 1 then
    table.insert(sources, require("none-ls.diagnostics.eslint_d"))
  end

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
    sources = sources,
  })

  vim.keymap.set("n", "<leader>fa", vim.lsp.buf.format, {})
end

return M

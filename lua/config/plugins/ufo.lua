local M = {}

function M.setup()
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
      -- Disable folding for specific filetypes
      local exclude = { "neo-tree", "alpha", "dashboard", "lazy", "mason" }
      if vim.tbl_contains(exclude, filetype) then
        return ""
      end
      return { "treesitter", "indent" }
    end,
  })

  -- Hide foldcolumn in Neo-tree and other non-code buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "neo-tree", "alpha", "dashboard", "lazy", "mason" },
    callback = function()
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.foldenable = false
    end,
  })

  -- Global fold management
  vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
  vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
  vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })

  -- Peek fold under cursor
  vim.keymap.set("n", "K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, { desc = "Peek fold or hover LSP" })
end

return M

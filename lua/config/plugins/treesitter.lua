local M = {}

function M.setup()
  local config = require("nvim-treesitter.configs")
  config.setup({
    auto_install = true,
    highlight = { enabled = true },
  })
end

return M

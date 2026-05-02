local M = {}

function M.setup()
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
  })
  vim.cmd.colorscheme("catppuccin")
end

return M

local M = {}

function M.setup()
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    integrations = {
      indent_blankline = {
        enabled = true,
        scope_color = "mauve", -- This sets the IblScope color
      },
    },
    custom_highlights = function(colors)
      return {
        IblIndent = { fg = colors.surface1 },
        IblScope = { fg = colors.mauve, style = { "bold" } },
      }
    end,
  })
  vim.cmd.colorscheme("catppuccin")
end

return M

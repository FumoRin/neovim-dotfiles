local M = {}

function M.setup()
  local ibl = require("ibl")

  ibl.setup({
    indent = {
      char = "│",
      tab_char = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = false,
      injected_languages = true,
      priority = 1024,
      highlight = "IblScope",
    },
    exclude = {
      filetypes = { "dashboard", "help", "neotree", "Trouble", "lazy", "mason" },
      buftypes = { "terminal", "nofile" },
    },
  })
end

return M

local M = {}

function M.setup()
  require("snacks").setup({
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
        conceal = function(lang, type)
          return type == "math"
        end,
      },
      math = {
        enabled = true,
      },
    },
  })
end

return M

local M = {}

function M.setup()
  require("render-markdown").setup({
    file_types = { "markdown" },
    ignore = function(buf)
      return vim.bo[buf].buftype == "nofile"
    end,
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = true,
      style = "language",
      left_pad = 2,
      right_pad = 2,
      width = "block",
    },
    table = {
      enabled = true,
      style = "full",
      cell = "padded",
    },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅒 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },
    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌷 ",
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰄲 " },
    },
    latex = {
      enabled = true,
      converter = { "utftex", "latex2text" },
      highlight = "RenderMarkdownMath",
      top_pad = 0,
      bottom_pad = 0,
    },
  })
end

return M

local M = {}

local parsers = {
  "bash",
  "css",
  "dockerfile",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local function is_markdown_float(buf)
  local filetype = vim.bo[buf].filetype
  return vim.bo[buf].buftype == "nofile" and (filetype == "markdown" or filetype == "markdown.inline")
end

function M.setup()
  local treesitter = require("nvim-treesitter")

  -- treesitter.setup()

  -- Register yaml.ansible to use the yaml parser
  vim.treesitter.language.register("yaml", "yaml.ansible")

  require("nvim-treesitter.configs").setup({
    ensure_installed = parsers,
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        return (lang == "markdown" or lang == "markdown_inline") and is_markdown_float(buf)
      end,
    },
    indent = {
      enable = true,
      disable = function(lang, buf)
        return (lang == "markdown" or lang == "markdown_inline") and is_markdown_float(buf)
      end,
    },
  })
end

return M

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
      -- disable = { "markdown" },
    },
    indent = {
      enable = true,
    },
  })
end

return M

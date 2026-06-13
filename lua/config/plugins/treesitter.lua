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

  treesitter.setup()

  -- LSP hover buffers are rendered as Markdown. With some AppImage/runtime +
  -- nvim-treesitter combinations, Markdown injections can crash in the
  -- set-lang-from-info-string! directive and leave highlighting broken.
  vim.treesitter.query.set("markdown", "injections", "")

  -- Register yaml.ansible to use the yaml parser
  vim.treesitter.language.register("yaml", "yaml.ansible")

  require("nvim-treesitter.configs").setup({
    ensure_installed = parsers,
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = { "markdown" },
    },
    indent = {
      enable = true,
    },
  })
end

return M

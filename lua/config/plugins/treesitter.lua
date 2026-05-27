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

local filetypes = {
  "bash",
  "css",
  "dockerfile",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "lua",
  "typescript",
  "typescriptreact",
  "yaml",
  "yaml.ansible",
}

function M.setup()
  local treesitter = require("nvim-treesitter")

  treesitter.setup()

  -- Register yaml.ansible to use the yaml parser
  vim.treesitter.language.register("yaml", "yaml.ansible")

  local installed = {}
  for _, parser in ipairs(treesitter.get_installed("parsers")) do
    installed[parser] = true
  end

  local missing = {}
  for _, parser in ipairs(parsers) do
    if not installed[parser] then
      table.insert(missing, parser)
    end
  end

  if #missing > 0 then
    local ok, task = pcall(treesitter.install, missing, { summary = true })
    if not ok then
      vim.notify("Treesitter parser install failed: " .. tostring(task), vim.log.levels.WARN)
    end
  end

  local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M

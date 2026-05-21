local M = {}

local parsers = {
  "bash",
  "css",
  "dockerfile",
  "html",
  "javascript",
  "json",
  "markdown",
  "markdown_inline",
  "tsx",
  "typescript",
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
  "typescript",
  "typescriptreact",
  "yaml",
}

function M.setup()
  local treesitter = require("nvim-treesitter")

  treesitter.setup()

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
    if vim.fn.executable("tree-sitter") == 0 then
      vim.notify(
        "Treesitter parsers missing; install tree-sitter CLI, then run :TSInstall " .. table.concat(missing, " "),
        vim.log.levels.WARN
      )
    else
      local ok, err = pcall(treesitter.install, missing, { summary = true })
      if not ok then
        vim.notify("Treesitter parser install failed: " .. tostring(err), vim.log.levels.WARN)
      end
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

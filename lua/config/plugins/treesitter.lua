local M = {}

function M.setup()
  local treesitter = require("nvim-treesitter")
  local languages = {
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

  if not treesitter.install then
    require("nvim-treesitter.configs").setup({
      ensure_installed = languages,
      highlight = { enable = true },
    })
    return
  end

  treesitter.setup()

  local missing = vim.tbl_filter(function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end, languages)

  if #missing > 0 then
    treesitter.install(missing)
  end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, filetype in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, filetype)
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)

      if vim.bo[args.buf].filetype ~= "markdown" then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M

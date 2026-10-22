local M = {}

M.parsers = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json",
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "svelte",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "yaml",
}

local filetypes = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "latex",
  "lua",
  "markdown",
  "sh",
  "svelte",
  "tex",
  "tsx",
  "typescript",
  "typescriptreact",
  "typst",
  "vim",
  "vimdoc",
  "yaml",
  "yaml.ansible",
}

local function is_markdown_float(buf)
  local filetype = vim.bo[buf].filetype
  return vim.bo[buf].buftype == "nofile" and (filetype == "markdown" or filetype == "markdown.inline")
end

function M.setup()
  local treesitter = require("nvim-treesitter")

  -- Register yaml.ansible to use the yaml parser
  vim.treesitter.language.register("yaml", "yaml.ansible")
  vim.treesitter.language.register("bash", "sh")
  vim.treesitter.language.register("tsx", "typescriptreact")
  vim.treesitter.language.register("javascript", "javascriptreact")

  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(args)
      if is_markdown_float(args.buf) then
        return
      end

      if pcall(vim.treesitter.start, args.buf) then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M

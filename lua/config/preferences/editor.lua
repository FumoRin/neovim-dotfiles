vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Set Line Number
vim.opt.relativenumber = true
vim.opt.number = true

-- Update file if changed externally
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.opt.autoread:get() and not vim.api.nvim_get_mode().mode:match("^[iR]") then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None",
})

-- Color Correction for detecting white mode
vim.opt.termguicolors = true


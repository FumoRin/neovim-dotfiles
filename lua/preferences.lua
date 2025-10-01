vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

-- For pasting into system clipboard
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- Terminal toggle function
function _G.toggle_term()
  local term_buf = vim.g.term_buf
  local term_win = vim.g.term_win

  -- If terminal already exists and visible, close it
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_close(term_win, true)
      vim.g.term_win = nil
    else
      -- Reopen in new split
      vim.cmd("belowright split")
      vim.api.nvim_win_set_buf(0, term_buf)
      vim.g.term_win = vim.api.nvim_get_current_win()
    end
  else
    -- Open a new terminal running PowerShell
    vim.cmd("belowright split")
    vim.cmd("terminal powershell -NoLogo")
    vim.g.term_buf = vim.api.nvim_get_current_buf()
    vim.g.term_win = vim.api.nvim_get_current_win()
  end
end

-- Set keymap: Ctrl + \ to toggle terminal
vim.keymap.set('n', '<C-\\>', toggle_term, { noremap = true, silent = true })

-- Set Line Number
vim.opt.relativenumber = true


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

-- Optional: Add a notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None",
})

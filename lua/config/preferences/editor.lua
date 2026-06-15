vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Set Line Number
vim.opt.relativenumber = true
vim.opt.number = true

-- Disable showmode
vim.opt.showmode = false

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

vim.opt.wrap = false

-- Ansible filetype detection
vim.filetype.add({
  extension = {
    yml = function(path, bufnr)
      local content = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
      local is_ansible = false
      for _, line in ipairs(content) do
        if line:match("hosts:") or line:match("tasks:") or line:match("roles:") or line:match("gather_facts:") then
          is_ansible = true
          break
        end
      end
      if is_ansible or path:match("ansible") or path:match("playbook") then
        return "yaml.ansible"
      end
      return "yaml"
    end,
    yaml = function(path, bufnr)
      local content = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
      local is_ansible = false
      for _, line in ipairs(content) do
        if line:match("hosts:") or line:match("tasks:") or line:match("roles:") or line:match("gather_facts:") then
          is_ansible = true
          break
        end
      end
      if is_ansible or path:match("ansible") or path:match("playbook") then
        return "yaml.ansible"
      end
      return "yaml"
    end,
  },
})

local M = {}

function M.setup()
  vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")

  require("neo-tree").setup({
    default_component_configs = {
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
    },
  })
end

return M

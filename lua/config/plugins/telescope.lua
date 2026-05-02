local M = {}

function M.setup_core()
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>f", builtin.find_files, {})
  vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
end

function M.setup_ui_select()
  require("telescope").setup({
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  })
  require("telescope").load_extension("ui-select")
end

return M

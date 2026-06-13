local M = {}

function M.setup_core()
  require("telescope").setup({
    defaults = {
      preview = {
        treesitter = false,
      },
    },
  })

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Fuzzy find files" })
  vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>lD", builtin.diagnostics, { desc = "Search diagnostics" })
  vim.keymap.set("n", "<leader>sk", function()
    builtin.keymaps({ show_plug = false })
  end, { desc = "[S]earch [K]eymaps" })
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

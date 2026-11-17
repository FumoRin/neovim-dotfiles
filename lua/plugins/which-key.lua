return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 500, -- ms to wait before popup appears
    icons = {
      mappings = true, -- show icons next to mappings
    },
    spec = {
      -- Group labels so the popup is organized
      { "<leader>l", group = "LSP" },
      { "<leader>h", group = "Git Hunks" },
      { "<leader>t", group = "Toggle" },
      { "<leader>s", group = "Search" },
    },
  },
}

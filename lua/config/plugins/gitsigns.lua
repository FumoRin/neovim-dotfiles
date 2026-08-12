local M = {}

function M.setup()
  require("gitsigns").setup({
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Next git hunk" })

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Previous git hunk" })

      -- Revert / Reset modified lines
      map("n", "<leader>ha", gs.reset_hunk, { desc = "Reset git hunk to HEAD" })
      map("v", "<leader>ha", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset selected lines to HEAD" })
      map("n", "<leader>hA", gs.reset_buffer, { desc = "Reset entire buffer to HEAD" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview git hunk" })

      -- Git Blame
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Git blame line popup" })
      map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle inline git blame" })
    end,
  })
end

return M


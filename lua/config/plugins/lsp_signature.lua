local M = {}

function M.setup()
  require("lsp_signature").setup({
    bind = true,
    doc_lines = 4,
    floating_window = false, -- Disable automatic popup; use virtual text and press <C-k> on demand
    floating_window_above_cur_line = true,
    fix_pos = false,
    hint_enable = true,
    hint_prefix = "󰏪 ",
    hi_parameter = "LspSignatureActiveParameter",
    handler_opts = {
      border = "rounded",
    },
    always_trigger = false,
    auto_close_after = nil,
    extra_trigger_chars = { "(", "," },
    toggle_key = "<C-k>", -- toggle signature popup in insert mode
  })
end

return M

return {
  -- Mason.nvim:
  {
    "mason-org/mason.nvim",
    -- `cmd` specifies commands that will trigger the loading of this plugin.
    -- This is a lazy-loading optimization.
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate", "MasonLog" },
    -- `opts` allows you to pass configuration options to the plugin.
    -- The `ui` option configures the Mason user interface.
    opts = {
      ui = {
        -- The border style for Mason's UI.
        -- Other options include: "none", "single", "double", "rounded", "solid", "shadow"
        border = "rounded",
        -- Icons used in the Mason UI.
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      -- Log level for Mason.
      -- Options: "trace", "debug", "info", "warn", "error", "fatal"
      log_level = vim.log.levels.INFO,
      -- A list of packages to automatically install when Mason loads.
      -- You can add LSPs, linters, or formatters here.
      -- For example:
      -- ensure_installed = { "lua-language-server", "stylua" },
      ensure_installed = {},
    },
    -- `config` is a function that runs after the plugin is loaded.
    -- You can put additional setup logic here.
    config = function(_, opts)
      require("mason").setup(opts)

      -- You can also create keymaps for Mason commands here for convenience.
      -- For example, to open Mason with <leader>m:
      -- vim.keymap.set("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Open Mason" })
    end,
  },

  -- Mason-lspconfig.nvim:
  {
    "mason-org/mason-lspconfig.nvim",
    -- `dependencies` ensures that mason.nvim is loaded before mason-lspconfig.nvim.
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    -- `opts` for mason-lspconfig.
    opts = {
      -- A list of servers to automatically install and set up.
      -- This is a good place to list the LSPs you use frequently.
      -- Example: ensure_installed = { "lua_ls", "rust_analyzer" }
      -- Note: `lua_ls` is the server name for `lua-language-server` in mason/nvim-lspconfig.
      -- You can find server names in mason.nvim or nvim-lspconfig documentation.
      ensure_installed = {
        -- Add your desired LSP servers here, for example:
        -- "pyright", -- For Python
        -- "tsserver", -- For TypeScript/JavaScript
        -- "gopls",    -- For Go
        -- "rust_analyzer" -- For Rust
      },
      -- `automatic_installation = true` will automatically install servers
      -- that are not yet installed when nvim-lspconfig attempts to set them up.
      -- This is useful if you define your LSP setups in nvim-lspconfig directly.
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Example of setting up a callback for when an LSP server attaches.
      -- This is where you would define keymaps specific to LSP features.
      -- local lspconfig = require("lspconfig")
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities() -- If using nvim-cmp

      -- require("mason-lspconfig").setup_handlers({
      --   -- The first entry (nil) will be the default handler and will be called for all servers.
      --   -- Alternatively, you can pass a server name (e.g. "lua_ls") to only apply
      --   -- the handler to a specific server.
      --   function(server_name) -- Default handler
      --     lspconfig[server_name].setup({
      --       -- capabilities = capabilities, -- Pass capabilities if using nvim-cmp or similar
      --       -- on_attach = function(client, bufnr)
      --       --   vim.notify("LSP attached: " .. server_name)
      --       --   -- Add buffer-local keymaps here, for example:
      --       --   -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
      --       --   -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
      --       -- end,
      --     })
      --   end,
      --   -- Example for a specific server:
      --   -- ["lua_ls"] = function ()
      --   --    lspconfig.lua_ls.setup({
      --   --        capabilities = capabilities,
      --   --        settings = {
      --   --            Lua = {
      --   --                diagnostics = {
      --   --                    globals = {'vim'} -- To make lua-language-server aware of `vim` global
      --   --                }
      --   --            }
      --   --        }
      --   --    })
      --   -- end,
      -- })
    end,
  },

  -- nvim-lspconfig:
  {
    "neovim/nvim-lspconfig",
  }
}


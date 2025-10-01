return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry"
        },
        PATH = "append",
      })
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" }, -- Critical dependency
    version = "1.29.0",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "yamlls", "dockerls" },
        automatic_installation = true,
        automatic_enable = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      lspconfig.dockerls.setup({
        capabilities = capabilities
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            completion = true,
            hover = true,
            validate = true,
            format = { enable = true },
            schemaStore = { enable = false },
            schemas = {
              -- Kubernetes
              ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.0-standalone-strict/all.json"] = {
                "*/k8s/**/*.yaml",
                "**/deployment.yaml",
                "**/service.yaml"
              },
              -- GitLab CI
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
              ".gitlab-ci.yml",
              -- GitHub Actions
              ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
              -- Helm Chart.yaml
              ["https://raw.githubusercontent.com/helm/chart-testing/main/schema/chart_schema.json"] = "*-Chart.yaml",
              -- Docker Compose schema
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                "**/docker-compose*.yaml",
                "**/docker-compose*.yml"
              }
            },
          },
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- Keymaps
      vim.keymap.set('n', 'H', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<C-j>', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}

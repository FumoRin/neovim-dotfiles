local M = {}

-- Kubernetes JSON schema URI (single source of truth)
local K8S_SCHEMA = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.33.8-standalone-strict/all.json"

-- Glob patterns that should always get the Kubernetes schema.
-- Files outside these patterns can still get it via <leader>ys or <leader>ym.
local K8S_GLOBS = {
  -- explicit directory conventions
  "k8s/**/*.yaml",
  "k8s/**/*.yml",
  "kubernetes/**/*.yaml",
  "kubernetes/**/*.yml",
  "manifests/**/*.yaml",
  "manifests/**/*.yml",
  "deploy/**/*.yaml",
  "deploy/**/*.yml",
  "helm/**/*.yaml",
  "helm/**/*.yml",
  -- common resource name fragments
  "*deployment*.yaml",
  "*deployment*.yml",
  "*service*.yaml",
  "*service*.yml",
  "*ingress*.yaml",
  "*ingress*.yml",
  "*configmap*.yaml",
  "*configmap*.yml",
  "*secret*.yaml",
  "*secret*.yml",
  "*gateway*.yaml",   -- e.g. gateway.yaml, api-gateway.yaml
  "*gateway*.yml",
  "*pod*.yaml",
  "*pod*.yml",
  "*cronjob*.yaml",
  "*cronjob*.yml",
  "*job*.yaml",
  "*job*.yml",
  "*daemonset*.yaml",
  "*daemonset*.yml",
  "*statefulset*.yaml",
  "*statefulset*.yml",
  "*namespace*.yaml",
  "*namespace*.yml",
  "*rbac*.yaml",
  "*rbac*.yml",
  "*clusterrole*.yaml",
  "*clusterrole*.yml",
  "*serviceaccount*.yaml",
  "*serviceaccount*.yml",
  "*hpa*.yaml",        -- HorizontalPodAutoscaler
  "*hpa*.yml",
  "*pvc*.yaml",        -- PersistentVolumeClaim
  "*pvc*.yml",
  "*pv*.yaml",         -- PersistentVolume
  "*pv*.yml",
}

function M.setup_mason()
  require("mason").setup({
    registries = {
      "github:mason-org/mason-registry",
    },
    PATH = "append",
  })
end

function M.setup_mason_lspconfig()
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "tsserver", "yamlls", "dockerls", "bashls" },
    automatic_installation = true,
    automatic_enable = false,
  })
end

function M.setup_lspconfig()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local servers = { "lua_ls", "bashls", "dockerls", "yamlls", "tsserver" }

  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        completion = true,
        hover      = true,
        validate   = true,
        format     = { enable = true },
        schemaStore = { enable = false },
        -- Pre-assign the Kubernetes schema by glob so yamlls can serve
        -- completions (apiVersion, kind, spec …) even on an empty new file.
        schemas = {
          [K8S_SCHEMA] = K8S_GLOBS,
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
          ["https://raw.githubusercontent.com/helm/chart-testing/main/schema/chart_schema.json"] = "*-Chart.yaml",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            "**/docker-compose*.yaml",
            "**/docker-compose*.yml",
          },
        },
      },
    },
  })

  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end

  -- ── LSP keymaps ──────────────────────────────────────────────────────────
  local lsp_keys = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_keys,
    callback = function(args)
      local opts = { buffer = args.buf }
      vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)
      vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, opts)
    end,
  })

  -- ── Kubernetes filetype hint via modeline ─────────────────────────────────
  -- For files that don't match any glob above, add this modeline at the top:
  --   # yaml-language-server: $schema=<K8S_SCHEMA>
end

return M

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
  "*serviceaccount*.yml",
  "*serviceaccount*.yaml",
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
  -- Map tsc lspconfig name to mason package
  local server_mappings = require("mason-lspconfig.mappings.server")
  server_mappings.lspconfig_to_package["tsc"] = "tsc"
  server_mappings.package_to_lspconfig["tsc"] = "tsc"

  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "tsc", "tsserver", "yamlls", "dockerls", "bashls", "tailwindcss", "ansiblels", "gopls", "astro", "cssls", "svelte" },
    automatic_installation = true,
    automatic_enable = false,
  })
end

function M.setup_lspconfig()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local servers = { "lua_ls", "bashls", "dockerls", "yamlls", "tsc", "tailwindcss", "ansiblels", "gopls", "astro", "cssls", "svelte" }

  if vim.lsp.handlers then
    if vim.lsp.handlers.hover then
      local hover_handler = vim.lsp.handlers.hover
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", config or {}, {
          border = "rounded",
        })
        return hover_handler(err, result, ctx, config)
      end
    end

    if vim.lsp.handlers.signature_help then
      local sig_handler = vim.lsp.handlers.signature_help
      vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", config or {}, {
          border = "rounded",
        })
        return sig_handler(err, result, ctx, config)
      end
    end
  end

  -- Global capabilities for all servers
  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  -- Specific config for gopls
  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })

  -- Specific config for yamlls
  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        completion = true,
        hover      = true,
        validate   = true,
        format     = { enable = true },
        schemaStore = { enable = false },
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

  -- astro-language-server needs an explicit TypeScript SDK location. Mason
  -- installs it alongside typescript-language-server.
  vim.lsp.config("astro", {
    init_options = {
      typescript = {
        tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
      },
    },
  })

  -- Enable servers using the native API
  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end

  -- ── Diagnostic Configuration ─────────────────────────────────────────────
  vim.diagnostic.config({
    update_in_insert = true, -- Update diagnostics while typing
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- ── LSP keymaps ──────────────────────────────────────────────────────────
  local lsp_keys = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_keys,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local opts = { buffer = args.buf }
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>lh", function()
        vim.lsp.buf.hover({ border = "rounded" })
      end, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
      vim.keymap.set("n", "<leader>ls", function()
        vim.lsp.buf.signature_help({ border = "rounded" })
      end, vim.tbl_extend("force", opts, { desc = "LSP Signature Help" }))
      vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP Code Action" }))
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP Rename" }))

      -- Navigation
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
      vim.keymap.set("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
      vim.keymap.set("n", "gi", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
      vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP Go to definition" }))
      vim.keymap.set("n", "<leader>lb", "<C-o>", vim.tbl_extend("force", opts, { desc = "Go back (Jump list)" }))

      -- Diagnostic navigation
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))
      vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic error" }))
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Open diagnostic list" }))

      -- ── Go Struct Tags (gopls interactive refactoring) ───────────────────
      if client and client.name == "gopls" then
        local function modify_go_struct_tags()
          local mode = vim.fn.mode()
          local range
          if mode:match("[vV\22]") then
            vim.cmd([[execute "normal! \<ESC>"]])
            local s = vim.fn.getpos("'<")
            local e = vim.fn.getpos("'>")
            range = {
              start = { line = s[2] - 1, character = math.max(0, s[3] - 1) },
              ["end"] = { line = e[2] - 1, character = math.max(0, e[3]) },
            }
          else
            local cur = vim.api.nvim_win_get_cursor(0)
            range = {
              start = { line = cur[1] - 1, character = cur[2] },
              ["end"] = { line = cur[1] - 1, character = cur[2] },
            }
          end

          local tag_options = {
            { label = "json",                  tag = "json",      options = "" },
            { label = "json (omitempty)",       tag = "json",      options = "json=omitempty" },
            { label = "yaml",                  tag = "yaml",      options = "" },
            { label = "yaml (omitempty)",       tag = "yaml",      options = "yaml=omitempty" },
            { label = "db",                    tag = "db",        options = "" },
            { label = "xml",                   tag = "xml",       options = "" },
            { label = "json,yaml",             tag = "json,yaml", options = "" },
            { label = "Custom tag...",         tag = "custom" },
            { label = "── Remove tag ──",       action = "remove" },
            { label = "── Clear all tags ──",   action = "clear" },
          }

          local casing_options = {
            { label = "camelCase   (e.g. firstName)",  val = "camelcase" },
            { label = "PascalCase  (e.g. FirstName)",  val = "pascalcase" },
            { label = "snake_case  (e.g. first_name)", val = "snakecase" },
            { label = "kebab-case  (e.g. first-name)", val = "lispcase" },
            { label = "keep        (original casing)", val = "keep" },
          }

          local function apply_modification(tag, options, transform)
            client:exec_cmd({
              command = "gopls.modify_tags",
              arguments = { {
                Modification = "add",
                Add = tag,
                AddOptions = options or "",
                Transform = transform,
                URI = vim.uri_from_bufnr(args.buf),
                Range = range,
              } },
            }, { bufnr = args.buf }, function(err)
              if err then
                vim.notify("gopls struct tags error: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
              else
                vim.notify("Updated struct tags: " .. tag .. " (" .. transform .. ")", vim.log.levels.INFO)
              end
            end)
          end

          vim.ui.select(tag_options, {
            prompt = "Select Struct Tag:",
            format_item = function(item) return item.label end,
          }, function(selected_tag)
            if not selected_tag then return end

            if selected_tag.action == "clear" then
              client:exec_cmd({
                command = "gopls.modify_tags",
                arguments = { {
                  Modification = "clear",
                  Clear = true,
                  URI = vim.uri_from_bufnr(args.buf),
                  Range = range,
                } },
              }, { bufnr = args.buf }, function(err)
                if err then
                  vim.notify("gopls struct tags error: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
                else
                  vim.notify("Cleared struct tags", vim.log.levels.INFO)
                end
              end)
              return
            end

            if selected_tag.action == "remove" then
              vim.ui.input({ prompt = "Tag to remove (e.g. json): ", default = "json" }, function(tag_to_remove)
                if not tag_to_remove or tag_to_remove == "" then return end
                client:exec_cmd({
                  command = "gopls.modify_tags",
                  arguments = { {
                    Modification = "remove",
                    Remove = tag_to_remove,
                    URI = vim.uri_from_bufnr(args.buf),
                    Range = range,
                  } },
                }, { bufnr = args.buf }, function(err)
                  if err then
                    vim.notify("gopls struct tags error: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
                  else
                    vim.notify("Removed struct tag: " .. tag_to_remove, vim.log.levels.INFO)
                  end
                end)
              end)
              return
            end

            local tag = selected_tag.tag
            local options = selected_tag.options or ""

            local function prompt_casing(tag_name, tag_opts)
              vim.ui.select(casing_options, {
                prompt = "Select Casing (" .. tag_name .. "):",
                format_item = function(item) return item.label end,
              }, function(selected_casing)
                if not selected_casing then return end
                apply_modification(tag_name, tag_opts, selected_casing.val)
              end)
            end

            if tag == "custom" then
              vim.ui.input({ prompt = "Custom tag name: " }, function(custom_tag)
                if not custom_tag or custom_tag == "" then return end
                prompt_casing(custom_tag, "")
              end)
            else
              prompt_casing(tag, options)
            end
          end)
        end

        vim.keymap.set({ "n", "v" }, "<leader>lt", modify_go_struct_tags, vim.tbl_extend("force", opts, { desc = "Go Struct Tags (interactive)" }))

        vim.api.nvim_buf_create_user_command(args.buf, "GoAddTags", function(cmd_opts)
          local tag = (cmd_opts.args ~= "") and cmd_opts.args or "json"
          local cur_range
          if cmd_opts.range == 2 then
            cur_range = {
              start = { line = cmd_opts.line1 - 1, character = 0 },
              ["end"] = { line = cmd_opts.line2, character = 0 },
            }
          else
            local cur = vim.api.nvim_win_get_cursor(0)
            cur_range = {
              start = { line = cur[1] - 1, character = cur[2] },
              ["end"] = { line = cur[1] - 1, character = cur[2] },
            }
          end
          client:exec_cmd({
            command = "gopls.modify_tags",
            arguments = { {
              Modification = "add",
              Add = tag,
              Transform = "snakecase",
              URI = vim.uri_from_bufnr(args.buf),
              Range = cur_range,
            } },
          }, { bufnr = args.buf }, function(err)
            if err then
              vim.notify("gopls struct tags error: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
            else
              vim.notify("Added struct tag: " .. tag, vim.log.levels.INFO)
            end
          end)
        end, { range = true, nargs = "?" })

        vim.api.nvim_buf_create_user_command(args.buf, "GoRemoveTags", function(cmd_opts)
          local tag = (cmd_opts.args ~= "") and cmd_opts.args or "json"
          local cur_range
          if cmd_opts.range == 2 then
            cur_range = {
              start = { line = cmd_opts.line1 - 1, character = 0 },
              ["end"] = { line = cmd_opts.line2, character = 0 },
            }
          else
            local cur = vim.api.nvim_win_get_cursor(0)
            cur_range = {
              start = { line = cur[1] - 1, character = cur[2] },
              ["end"] = { line = cur[1] - 1, character = cur[2] },
            }
          end
          client:exec_cmd({
            command = "gopls.modify_tags",
            arguments = { {
              Modification = "remove",
              Remove = tag,
              URI = vim.uri_from_bufnr(args.buf),
              Range = cur_range,
            } },
          }, { bufnr = args.buf }, function(err)
            if err then
              vim.notify("gopls struct tags error: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
            else
              vim.notify("Removed struct tag: " .. tag, vim.log.levels.INFO)
            end
          end)
        end, { range = true, nargs = "?" })
      end
    end,
  })

  -- ── Kubernetes filetype hint via modeline ─────────────────────────────────
  -- For files that don't match any glob above, add this modeline at the top:
  --   # yaml-language-server: $schema=<K8S_SCHEMA>
end

return M

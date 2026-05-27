# Neovim Dotfiles — Agent Reference

This document gives AI coding agents full context about this Neovim configuration: its goals, structure, plugin stack, and conventions. Read this before making any changes.

---

## Project Goal

Turn Neovim into a full IDE experience comparable to VS Code or JetBrains IDEs, with:

- **Intelligent autocompletion** — context-aware suggestions from LSP, snippets, and buffer
- **Easy LSP configuration** — install and manage language servers without manual setup
- **Inline diagnostics & error notifications** — errors, warnings, and hints visible in-editor
- **Syntax-aware editing** — Treesitter-based highlighting, folding, and text objects
- **File navigation** — file tree sidebar and fuzzy finder for files, symbols, and grep
- **IDE-like UI** — statusline, dashboard, icons, indent guides, and git decorations
- **Code formatting & linting** — auto-format on save, linting via null-ls integrations

---

## Repository Layout

```
~/.config/nvim/
├── init.lua                  # Entry point: bootstraps lazy.nvim, loads config + plugins
├── lazy-lock.json            # Pinned plugin commits (do not edit manually)
├── .luarc.json               # Lua LSP settings for the config itself
└── lua/
    ├── config/
    │   └── preferences/
    │       └── preferences.lua   # Core vim options (lines, tabs, UI, etc.)
    └── plugins/                  # One file (or folder) per plugin, auto-loaded by lazy.nvim
```

`init.lua` does two things: loads `config.preferences.preferences` first (so options are set before plugins), then hands off to `require("lazy").setup("plugins")` which auto-discovers every spec file under `lua/plugins/`.

---

## Plugin Stack

### Package Manager
| Plugin | Purpose |
|--------|---------|
| `folke/lazy.nvim` | Plugin manager — lazy-loads by event/cmd/ft for fast startup |

### LSP & Language Intelligence
| Plugin | Purpose |
|--------|---------|
| `neovim/nvim-lspconfig` | Base LSP client configuration |
| `williamboman/mason.nvim` | GUI installer for LSP servers, linters, and formatters |
| `williamboman/mason-lspconfig.nvim` | Bridges mason ↔ lspconfig so installed servers auto-attach |
| `b0o/schemastore.nvim` | JSON/YAML schema catalogue fed into jsonls/yamlls for validation |

### Completion
| Plugin | Purpose |
|--------|---------|
| `hrsh7th/nvim-cmp` | Completion engine |
| `hrsh7th/cmp-nvim-lsp` | LSP source for nvim-cmp |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `saadparwaiz1/cmp_luasnip` | LuaSnip source for nvim-cmp |
| `rafamadriz/friendly-snippets` | VS Code-style community snippet library |

### Linting & Formatting (null-ls ecosystem)
| Plugin | Purpose |
|--------|---------|
| `nvimtools/none-ls.nvim` | Inject external linters/formatters as LSP sources |
| `nvimtools/none-ls-extras.nvim` | Extra built-in sources (eslint_d, prettier, etc.) |
| `gbprod/none-ls-shellcheck.nvim` | Shell script linting via shellcheck |

### Syntax & Treesitter
| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter/nvim-treesitter` | AST-based highlighting, indenting, folding, text objects |

### File Navigation
| Plugin | Purpose |
|--------|---------|
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, buffers, grep, LSP symbols |
| `nvim-telescope/telescope-ui-select.nvim` | Routes `vim.ui.select` through Telescope (code actions, etc.) |
| `nvim-neo-tree/neo-tree.nvim` | File explorer sidebar (VS Code–style) |

### UI & Appearance
| Plugin | Purpose |
|--------|---------|
| `catppuccin/nvim` | Colorscheme (catppuccin) |
| `nvim-lualine/lualine.nvim` | Statusline |
| `goolord/alpha-nvim` | Start dashboard |
| `lukas-reineke/indent-blankline.nvim` | Indent guide lines |
| `nvim-tree/nvim-web-devicons` | File-type icons |
| `echasnovski/mini.icons` | Additional icon provider |

### Git
| Plugin | Purpose |
|--------|---------|
| `lewis6991/gitsigns.nvim` | Inline git blame, hunk signs, hunk navigation |

### Editor Quality-of-Life
| Plugin | Purpose |
|--------|---------|
| `windwp/nvim-autopairs` | Auto-close brackets, quotes, etc. |

### Dependencies / Utilities
| Plugin | Purpose |
|--------|---------|
| `nvim-lua/plenary.nvim` | Async utils used by telescope, gitsigns, etc. |
| `MunifTanjim/nui.nvim` | UI component library used by neo-tree |

---

## Conventions & Patterns

### Adding a new plugin
Create a new file under `lua/plugins/` returning a lazy.nvim spec table:

```lua
-- lua/plugins/example.lua
return {
  "author/plugin-name",
  event = "VeryLazy",          -- defer loading
  dependencies = { ... },
  opts = { ... },              -- prefer opts over config when possible
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

Lazy auto-discovers all `.lua` files in `lua/plugins/`.

### Adding a new LSP server
1. Open Mason (`:Mason`) and install the server.
2. Add the server name to the `ensure_installed` list in `lua/config/plugins/lsp.lua` (inside `M.setup_mason_lspconfig`).
3. Add the server name to the `servers` list in `lua/config/plugins/lsp.lua` (inside `M.setup_lspconfig`).
4. If the server requires custom settings, use `vim.lsp.config("<server_name>", { settings = { ... } })` in `M.setup_lspconfig`.

### Adding a formatter or linter (null-ls)
Register new sources in `lua/config/plugins/null_ls.lua`:

```lua
local sources = {
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.diagnostics.ansiblelint,
  -- ...
}
```
Check the [none-ls builtins](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md) for available names.

### Keymaps
Keymaps are co-located with the plugin that owns them (inside the plugin's `config` or `keys` lazy field). Do **not** create a separate global keymap file unless there is a compelling reason — discoverability matters.

---

## IDE Feature Checklist

Use this to track progress toward full IDE parity:

- [x] LSP (go-to-definition, hover, references, rename)
- [x] Autocompletion with snippets
- [x] Inline diagnostics (errors / warnings / hints)
- [x] Code actions via Telescope UI select
- [x] File tree sidebar
- [x] Fuzzy file / symbol search
- [x] Git decorations (blame, hunks)
- [x] Auto-pairs
- [x] Syntax highlighting (Treesitter)
- [x] Indent guides
- [x] Integrated terminal (e.g. `toggleterm.nvim`)
- [x] Advanced Folding (nvim-ufo)
- [ ] Breadcrumb / winbar showing current symbol
- [ ] Session management (e.g. `persistence.nvim`)

---

## Key Keymaps

### Folding (nvim-ufo)
| Key | Action | Scope |
|-----|--------|-------|
| `za` | Toggle fold | Current level |
| `zA` | Toggle fold recursive | Current + all children |
| `zc` / `zo` | Close / Open fold | Current level |
| `zC` / `zO` | Close / Open recursive | Current + all children |
| `zM` | Close all folds | Buffer-wide |
| `zR` | Open all folds | Buffer-wide |
| `zm` | Fold more | Incremental level |
| `zr` | Fold less | Incremental level |
| `K`  | Peek fold | Preview content without opening |

---

## Key Dependencies Between Plugins

```
nvim-cmp
  ├── cmp-nvim-lsp  ──→  nvim-lspconfig
  │                         └── mason-lspconfig ──→ mason.nvim
  ├── cmp_luasnip  ──→  LuaSnip
  │                         └── friendly-snippets
  └── (buffer, path sources can be added separately)

telescope.nvim
  ├── plenary.nvim
  └── telescope-ui-select  (replaces vim.ui.select globally)

neo-tree.nvim
  ├── nui.nvim
  ├── plenary.nvim
  └── nvim-web-devicons / mini.icons

none-ls.nvim
  ├── none-ls-extras.nvim
  └── none-ls-shellcheck.nvim
```

---

## Notes for Agents

- **Lua version**: Neovim embeds LuaJIT. Always use Lua 5.1-compatible syntax.
- **Do not touch `lazy-lock.json`** directly. It is updated automatically by `:Lazy update`.
- **`.luarc.json`** configures `lua_ls` for this config directory — keep it in sync if new library paths are added.
- **Prefer `opts =` over `config =`** in plugin specs whenever the plugin supports `setup()` with a plain table.
- **Plugin ordering** within a single spec file does not matter; lazy.nvim resolves load order from `dependencies`.
- **Test changes** by restarting Neovim or running `:Lazy reload <plugin>`. Use `:checkhealth` for diagnostics.

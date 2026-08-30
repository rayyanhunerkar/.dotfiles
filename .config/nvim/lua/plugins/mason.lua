-- Every LSP / formatter / linter / debugger, declared so a fresh machine
-- reproduces the same toolchain. Names must match those shown in `:Mason`.

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- ── language servers ────────────────────────────────────────────
        "lua-language-server",
        "vtsls", -- TypeScript/JS; more capable than typescript-language-server
        "gopls",
        "basedpyright", -- Python types (free fork of pyright)
        "ruff", -- Python lint + format, ships its own LSP
        "rust-analyzer",
        "bash-language-server",
        "marksman", -- Markdown
        "yaml-language-server",
        "json-lsp",
        "taplo", -- TOML
        "dockerfile-language-server",
        "docker-compose-language-service",
        "helm-ls",
        "terraform-ls",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "eslint-lsp",
        "graphql-language-service-cli",
        "lemminx", -- XML
        "sqls",

        -- ── formatters ──────────────────────────────────────────────────
        "stylua", -- lua        (.stylua.toml at the config root)
        "prettierd", -- js/ts/json/yaml/md/html/css — daemon, much faster
        "prettier", -- fallback when prettierd misbehaves
        "gofumpt", -- go, stricter gofmt
        "goimports", -- go, import management
        "shfmt", -- shell
        "sql-formatter",

        -- ── linters ─────────────────────────────────────────────────────
        "selene", -- lua        (selene.toml at the config root)
        "golangci-lint",
        "shellcheck",
        "hadolint", -- Dockerfile
        "markdownlint-cli2",
        "yamllint",

        -- ── debuggers ───────────────────────────────────────────────────
        "debugpy",
        "delve", -- go
        "js-debug-adapter",

        -- ── misc ────────────────────────────────────────────────────────
        "tree-sitter-cli",
      },
      -- Install in the background instead of blocking the first buffer.
      run_on_start = true,
      start_delay = 3000,
    },
  },
}

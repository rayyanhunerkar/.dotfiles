-- AstroCommunity language packs.
--
-- Imported before `plugins/`, so anything here can be overridden there. Each
-- pack pulls in the treesitter parsers, LSP wiring and test/debug adapters for
-- its language; `plugins/mason.lua` then pins the actual binaries so a fresh
-- machine installs the same set.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Editor behaviour
  { import = "astrocommunity.recipes.vscode-icons" },

  -- Web / TypeScript
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.prettier" },

  -- Go
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.golangci-lint" },

  -- Python. `base` + `ruff` rather than the default black/isort: ruff replaces
  -- both and is the same toolchain family as uv. basedpyright does the types.
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.python.basedpyright" },

  -- Systems / other common
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.sql" },

  -- Markup and config formats
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.xml" },

  -- Infra
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.terraform" },
}

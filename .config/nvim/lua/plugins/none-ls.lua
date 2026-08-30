-- Formatters and linters that aren't language servers.
--
-- The astrocommunity prettier / eslint / golangci-lint packs register their own
-- sources, and the json/yaml packs already pull in schemastore.nvim and wire the
-- schemas into jsonls/yamlls — don't re-declare it here, a second spec under a
-- different capitalisation makes lazy.nvim loop forever on "missing plugins".
--
-- This file adds what no pack covers, and finally puts the .stylua.toml and
-- selene.toml sitting at the config root to use.

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require "null-ls"
    opts.sources = opts.sources or {}

    vim.list_extend(opts.sources, {
      -- formatters
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.shfmt.with { extra_args = { "-i", "2", "-ci" } },
      nls.builtins.formatting.gofumpt,
      nls.builtins.formatting.goimports,

      -- linters
      nls.builtins.diagnostics.selene.with {
        -- Only run where the project actually has a selene config.
        condition = function(utils) return utils.root_has_file { "selene.toml" } end,
      },
      nls.builtins.diagnostics.hadolint,
      nls.builtins.diagnostics.markdownlint_cli2,
      nls.builtins.diagnostics.yamllint.with {
        extra_args = { "-d", "{extends: relaxed, rules: {line-length: disable}}" },
      },
    })

    return opts
  end,
}

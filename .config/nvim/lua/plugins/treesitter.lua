-- Extra parsers on top of what the astrocommunity packs already install.

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = {
        -- config formats the packs don't cover
        "ini",
        "ssh_config",
        "git_config",
        "gitignore",
        "gitcommit",
        "git_rebase",
        "diff",
        "dockerfile",
        "make",
        "cmake",
        "nginx",
        "passwd",
        "json5",
        "hjson",
        "editorconfig",
        "requirements",
        -- shell / scripting
        "bash",
        "awk",
        "regex",
        -- markup
        "html",
        "markdown",
        "markdown_inline",
        "rst",
        "latex",
        -- misc common
        "graphql",
        "prisma",
        "proto",
        "sql",
        "vim",
        "vimdoc",
        "lua",
        "luadoc",
        "query",
        "printf",
        "comment",
      },
    },
  },
}

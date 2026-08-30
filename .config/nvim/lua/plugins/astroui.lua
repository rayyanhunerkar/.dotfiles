-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- "dotfiles" is generated: `set-theme` copies the active palette from
    -- .config/nvim/themes/<name>.lua to colors/dotfiles.lua. Falls back to
    -- astrodark if that file isn't there yet (fresh checkout, before install).
    colorscheme = vim.fn.filereadable(vim.fn.stdpath "config" .. "/colors/dotfiles.lua") == 1
        and "dotfiles"
      or "astrodark",
    highlights = {
      init = {},
    },
    icons = {
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}

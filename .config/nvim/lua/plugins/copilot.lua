-- Inline tab completion.
--
-- Copilot rather than Claude on purpose: it is fill-in-the-middle trained and
-- answers in ~200ms on a flat monthly fee, where a chat model driving
-- completions costs per keystroke and lands around a second. Claude does the
-- agentic work instead — see claude.lua.

---@type LazySpec
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      -- Ghost text and the blink.cmp menu would otherwise draw over each other.
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = false, -- bound to <Tab> below, with fallbacks
        accept_word = "<M-w>",
        accept_line = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<M-e>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      -- Don't leak buffer contents from these to the Copilot backend.
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
      ["dotenv"] = false,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)

    -- <Tab> precedence: the completion menu wins if it's open, then a Copilot
    -- ghost suggestion, then a snippet jump, and finally a literal tab.
    -- Ordering matters — Copilot first would swallow menu navigation.
    vim.keymap.set("i", "<Tab>", function()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink and blink.is_visible() then
        blink.select_next()
        return
      end

      local ok_sug, suggestion = pcall(require, "copilot.suggestion")
      if ok_sug and suggestion.is_visible() then
        suggestion.accept()
        return
      end

      if vim.snippet and vim.snippet.active { direction = 1 } then
        vim.snippet.jump(1)
        return
      end

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end, { desc = "Menu / Copilot / snippet / tab" })
  end,
}

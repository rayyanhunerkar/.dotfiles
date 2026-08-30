-- Claude Code in Neovim.
--
-- claudecode.nvim runs a WebSocket server implementing the same MCP protocol as
-- the official VS Code extension, and the `claude` CLI connects back to it. Pure
-- Lua — no Node or Python bridge. snacks.nvim (already shipped by AstroNvim)
-- provides the terminal.
--
-- Inline tab completion is Copilot's job, not Claude's — see copilot.lua.

---@type LazySpec
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "snacks",
      auto_close = false,
    },
    diff_opts = {
      -- Review Claude's edits as a normal diff split before accepting.
      auto_close_on_accept = true,
      vertical_split = true,
    },
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    -- AstroNvim already uses <leader>a for its own group, so Claude lives on
    -- <leader>k ("klaude") to avoid shadowing it.
    { "<leader>k", nil, desc = "Claude" },
    { "<leader>kk", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>kf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>kr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
    { "<leader>kc", "<cmd>ClaudeCode --continue<cr>", desc = "Continue session" },
    { "<leader>km", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<leader>kb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>ks", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
    {
      "<leader>ks",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file from tree",
      ft = { "neo-tree", "NvimTree", "oil", "minifiles", "snacks_picker_list" },
    },
    { "<leader>ky", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>kn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    { "<leader>k?", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },
  },
}

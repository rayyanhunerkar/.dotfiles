-- LSP behaviour and per-server settings. `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false, -- toggle per-buffer with <leader>uH
      semantic_tokens = true,
    },

    -- Format on save, except where a project has no agreed style.
    formatting = {
      format_on_save = {
        enabled = true,
        ignore_filetypes = { "sql" },
      },
      disabled = {
        -- vtsls/basedpyright formatting is worse than the dedicated tools;
        -- prettier and ruff handle these instead.
        "vtsls",
        "basedpyright",
        "yamlls",
        "jsonls",
        "html",
        "cssls",
      },
      timeout_ms = 3000,
    },

    -- The astrocommunity typescript pack sets up ts_ls; vtsls supersedes it and
    -- both attaching means duplicate diagnostics and double the CPU per
    -- keystroke. `false` stops AstroLSP from ever calling setup on it. tsgo and
    -- ty are the same story: they overlap vtsls and basedpyright.
    handlers = {
      ts_ls = false,
      tsgo = false,
      ty = false,
    },

    config = {
      -- ── Lua ───────────────────────────────────────────────────────────
      lua_ls = {
        settings = {
          Lua = {
            hint = { enable = true, arrayIndex = "Disable" },
            workspace = { checkThirdParty = false },
          },
        },
      },

      -- ── Python ────────────────────────────────────────────────────────
      -- uv puts its virtualenv at .venv; point basedpyright at that
      -- interpreter so imports resolve without activating the venv first.
      basedpyright = {
        before_init = function(_, config)
          local root = config.root_dir or vim.fn.getcwd()
          local venv = root .. "/.venv"
          if vim.fn.isdirectory(venv) == 1 then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.venvPath = root
            config.settings.python.venv = ".venv"
            config.settings.python.pythonPath = venv .. "/bin/python"
          end
        end,
        settings = {
          basedpyright = {
            analysis = {
              -- "recommended" is very loud on existing codebases.
              typeCheckingMode = "standard",
              diagnosticMode = "openFilesOnly",
              inlayHints = { variableTypes = true, functionReturnTypes = true },
            },
          },
        },
      },

      -- ── YAML ──────────────────────────────────────────────────────────
      -- Schemas themselves come from the astrocommunity yaml pack, which wires
      -- schemastore.nvim in; only behaviour is set here.
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
            format = { enable = false },
            validate = true,
          },
        },
      },

      -- ── TypeScript ────────────────────────────────────────────────────
      vtsls = {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
            },
          },
        },
      },
    },

    mappings = {
      n = {
        gd = { function() vim.lsp.buf.definition() end, desc = "Go to definition" },
        gr = { function() vim.lsp.buf.references() end, desc = "References" },
        ["<leader>lR"] = { function() vim.lsp.buf.rename() end, desc = "Rename symbol" },
      },
    },
  },
}

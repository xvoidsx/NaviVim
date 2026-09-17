-- Polyglot LSP on Neovim's native 0.11+ API (vim.lsp.config + vim.lsp.enable).
-- No nvim-lspconfig framework (deprecated upstream, noisy on 0.12) and no
-- mason-lspconfig middleman: Mason installs the servers, we wire them
-- explicitly below. One place to add/remove a language.

local MASON_BIN = vim.fn.stdpath("data") .. "/mason/bin/"

local servers = {
  lua_ls = {
    cmd = { MASON_BIN .. "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", "selene.toml", ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  pyright = {
    cmd = { MASON_BIN .. "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  },
  ts_ls = {
    cmd = { MASON_BIN .. "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  rust_analyzer = {
    cmd = { MASON_BIN .. "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  },
  gopls = {
    cmd = { MASON_BIN .. "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
  },
  clangd = {
    cmd = { MASON_BIN .. "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  },
  bashls = {
    cmd = { MASON_BIN .. "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    root_markers = { ".git" },
  },
  jsonls = {
    cmd = { MASON_BIN .. "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { "package.json", ".git" },
  },
  yamlls = {
    cmd = { MASON_BIN .. "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_markers = { ".git" },
  },
}

-- Mason package names for everything above, plus formatters/linters.
local mason_packages = {
  "stylua", "shellcheck", "shfmt", "flake8", "black", "isort", "prettier",
  "lua-language-server", "pyright", "typescript-language-server",
  "rust-analyzer", "gopls", "clangd", "bash-language-server",
  "json-lsp", "yaml-language-server",
}

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = { "BufReadPre", "BufNewFile" },
    opts = { ensure_installed = mason_packages },
    config = function(_, opts)
      require("mason").setup()
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() and not p:is_installing() then
            p:install()
          end
        end
      end)

      -- Wire every server through the native API.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end

      -- LSP keys (VSCode-like)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local m = vim.keymap.set
          local o = { buffer = ev.buf, silent = true }
          m("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Go to definition" }))
          m("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", o, { desc = "References" }))
          m("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Hover docs" }))
          m("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", o, { desc = "Rename symbol" }))
          m("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code action" }))
          m("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", o, { desc = "Prev diagnostic" }))
          m("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", o, { desc = "Next diagnostic" }))
        end,
      })
    end,
  },
  {
    -- LSP status eye-candy
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    -- Format on save (toggleable via <leader>uf)
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<leader>uf",
        function()
          vim.g.navi_format_on_save = not vim.g.navi_format_on_save
          vim.notify("Format on save " .. (vim.g.navi_format_on_save == false and "DISABLED" or "ENABLED"))
        end,
        desc = "Toggle format on save",
      },
    },
    init = function()
      vim.g.navi_format_on_save = true
    end,
    opts = {
      format_on_save = function()
        if vim.g.navi_format_on_save == false then
          return nil
        end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        sh = { "shfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- Only register linters that are actually installed: otherwise every
      -- buffer enter prints an ENOENT error (install via :Mason or apt).
      lint.linters_by_ft = {}
      if vim.fn.executable("flake8") == 1 then
        lint.linters_by_ft.python = { "flake8" }
      end
      if vim.fn.executable("shellcheck") == 1 then
        lint.linters_by_ft.sh = { "shellcheck" }
      end
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

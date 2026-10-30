-- lua/plugins.lua (lazy.nvim spec)
return {
  -- LSP
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ts_ls", "basedpyright", "ruff", "clangd",
        "djlsp", "djls", "jinja_lsp", "biome",
      },
    },
  },

  -- Formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format" },
    },
    config = true, -- loads lua/formatters.lua
  },

  -- Mason tools (non-LSP binaries)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", "clang-format", "stylua", "ruff", "biome",
      },
    },
  },
}   

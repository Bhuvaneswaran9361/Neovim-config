-- lua/formatters.lua (or inside a lazy.nvim plugin spec)

require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback", -- use LSP format if no conform formatter matches
  },
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },

    -- Python: ruff handles both import sorting + formatting
    python = { "ruff_organize_imports", "ruff_format" },

    -- C / C++
    c = { "clang_format" },
    cpp = { "clang_format" },

    -- JS / TS: prefer biome if configured in project, fall back to prettier
    javascript = { "biome", "biome-organize-imports", "prettier", stop_after_first = true },
    typescript = { "biome", "biome-organize-imports", "prettier", stop_after_first = true },
    javascriptreact = { "biome", "biome-organize-imports", "prettier", stop_after_first = true },
    typescriptreact = { "biome", "biome-organize-imports", "prettier", stop_after_first = true },

    -- Other prettier filetypes
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
  },
  formatters = {
    -- Only run biome if biome.json exists in project
    biome = { require_cwd = true },
    "biome-organize-imports" = { require_cwd = true },
  },
})   

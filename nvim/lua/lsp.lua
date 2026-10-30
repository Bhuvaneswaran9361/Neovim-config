-- lua/lsp.lua

-- Global defaults for all LSP servers
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- if using nvim-cmp
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, opts)
  end,
})

-- ─── TypeScript / React ───────────────────────────────────────────
vim.lsp.config("ts_ls", {
  settings = {
    completeFunctionCalls = true,
  },
})


-- Helper: resolve the correct Python interpreter
local function python_path(root_dir)
  -- 1. Activated venv (if you launched nvim from inside one)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  -- 2. Project-local venvs (check in priority order)
  local candidates = { ".venv", "venv", ".env" }
  for _, name in ipairs(candidates) do
    local p = root_dir .. "/" .. name .. "/bin/python"
    if vim.fn.filereadable(p) == 1 then
      return p
    end
  end
  -- 3. System Python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- ─── basedpyright ─────────────────────────────────────────────────
vim.lsp.config("basedpyright", {
  root_markers = {
    "pyproject.toml",
    "pyrightconfig.json",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "uv.lock",
    ".python-version",
    ".venv",
    "venv",
    ".env",
    ".git",
  },
  settings = {
    python = {
      -- Resolved at attach time via on_attach below
    },
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
  on_attach = function(client)
    local root = client.root_dir or vim.fn.getcwd()
    client.config.settings.python.pythonPath = python_path(root)
    client:restart() -- apply the new interpreter
  end,
})

-- ─── ruff ─────────────────────────────────────────────────────────
vim.lsp.config("ruff", {
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    "requirements.txt",
    ".venv",
    "venv",
    ".env",
    ".git",
  },
  init_options = {
    settings = {
      -- ruff reads its own config from pyproject.toml / ruff.toml
    },
  },
})   

-- ─── C / C++ ──────────────────────────────────────────────────────
vim.lsp.config("clangd", {
  init_options = {
    clangdDirectory = nil, -- let it find .clangd / compile_commands.json
  },
})

-- ─── Django / Jinja ───────────────────────────────────────────────
vim.lsp.config("djlsp", {
  init_options = {
    -- Set your Django settings module:
    -- django_settings_module = "myproject.settings",
  },
})

vim.lsp.config("djls", {
  -- django-language-server (djls)
})

vim.lsp.config("jinja_lsp", {
  filetypes = { "jinja", "jinja.html", "htmldjango" },
  root_markers = { ".git", "pyproject.toml", "jinja.toml" },
})

-- ─── Biome (JS/TS) ────────────────────────────────────────────────
vim.lsp.config("biome", {
  root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
})

-- ─── Enable all servers ───────────────────────────────────────────
vim.lsp.enable({
  "ts_ls",
  "basedpyright",
  "ruff",
  "clangd",
  "djlsp",
  "djls",
  "jinja_lsp",
  "biome",
})   

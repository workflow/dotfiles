local shared_lsp_config = require('shared_lsp_config')

-- General Diagnostic keymaps
local wk = require("which-key")
local lspsaga = require("lspsaga")
wk.add(
  {
    { "<localleader>d", vim.diagnostic.open_float,               desc = "Open Floating [D]iagnostics" },
    { "<localleader>l", vim.diagnostic.setloclist,               desc = "Open Diagnostics in [L]ocation List" },
    { "<localleader>q", vim.diagnostic.setqflist,                desc = "Open Diagnostics in [Q]uickfix List" },
    { "[d",             "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev [D]iagnostic" },
    { "]d",             "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next [D]iagnostic" },
  }
)

-- Autoformat, from https://github.com/nvim-lua/kickstart.nvim/blob/master/lua/kickstart/plugins/autoformat.lua
-- Switch for controlling whether you want autoformatting.
--  Use :AutoFormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('AutoFormatToggle', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

-- Create an augroup that is used for managing our formatting autocmds.
--      We need one augroup per client to make sure that multiple clients
--      can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'kickstart-lsp-format-' .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

-- Whenever an LSP attaches to a buffer, we will run this function.
--
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
  -- This is where we attach the autoformatting for reasonable clients
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = args.buf

    -- Only attach to clients that support document formatting
    if not client.server_capabilities.documentFormattingProvider then
      return
    end

    -- Tsserver usually works poorly. Sorry you work with bad languages
    -- You can remove this line if you know what you're doing :)
    if client.name == 'tsserver' then
      return
    end

    -- Create an autocmd that will run *before* we save the buffer.
    --  Run the formatting command for the LSP that has just attached.
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = get_augroup(client),
      buffer = bufnr,
      callback = function()
        if not format_is_enabled then
          return
        end

        vim.lsp.buf.format {
          async = false,
          filter = function(c)
            return c.id == client.id
          end,
        }
      end,
    })
  end,
})

-- Document workspace keymap
require('which-key').add(
  {
    { "<leader>w",  group = "[W]orkspace" },
    { "<leader>w_", hidden = true },
  }
)

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the LSP servers.
require('mason').setup()
require('mason-lspconfig').setup()
require("mason-nvim-dap").setup({
  -- automatic_installation = true,
  ensure_installed = {
    "codelldb",
    "javadbg",
    "javatest",
  },
})

local servers = {
  bashls = {},
  jdtls = {}, -- java
  jsonls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- diagnostics = { disable = { 'missing-fields', 'undefined-global' } },
    },
  },
  julials = {},
  pyright = {},
  ruff = {},
  rust_analyzer = {
    checkOnSave = {
      command = 'clippy',
    },
  },
  terraformls = {},
  tflint = {},
  ts_ls = {},
  yamlls = {
    schemas = {
      kubernetes = "*.yaml",
      ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
      ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
      ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
      ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
      ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
      ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
      ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
      ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
      "*docker-compose*.{yml,yaml}",
      ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
      "*flow*.{yml,yaml}",
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- UFO extension
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
  function(server_name)
    -- JDTLs is managed by the jdtls-nvim plugin which starts its own LSP client
    -- But we still manage the installation via Mason
    if server_name == 'jdtls' then
      return
    end
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = shared_lsp_config.on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- Nixd
require('lspconfig').nixd.setup {
  capabilities = capabilities,
  on_attach = shared_lsp_config.on_attach,
  settings = {
    nixd = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
}

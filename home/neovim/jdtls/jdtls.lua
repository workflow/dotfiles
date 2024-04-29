local shared_lsp_config = require('shared_lsp_config')
local root_dir = require('jdtls.setup').find_root({ '.git' });
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local data_dir = vim.fn.expand('$HOME/.cache/nvim/jdtls/workspaces/') .. project_name

local jdtls_path = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/jdtls')
local jdebug_path = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/java-debug-adapter')
local jtest_path = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/java-test')


local bundles = {
  vim.fn.glob(jdebug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(jtest_path .. "/extension/server/*.jar", true), "\n"))

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local on_attach = function(_, bufnr)
  shared_lsp_config.on_attach(_, bufnr)

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local wk = require("which-key")
  wk.register({
    e = "[E]xtract",
  }, { prefix = "<localleader>" })
  nmap('<localleader>o', require('jdtls').organize_imports, '[O]rganize Imports')
  nmap('<localleader>ev', require('jdtls').extract_variable, '[V]ariable')
  nmap('<localleader>ec', require('jdtls').extract_constant, '[C]onstant')
  nmap('<localleader>em', require('jdtls').extract_method, '[M]ethod')
  -- " If using nvim-dap
  -- " This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
  -- nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
  -- nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
  -- require('jdtls').setup_dap({ hotcodereplace = "auto" })
  -- require('jdtls.dap').setup_dap_main_class_configs()
  -- require('jdtls.setup').add_commands()
end


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', jdtls_path .. '/config_linux',
    '-data', data_dir,
  },

  on_attach = on_attach,

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

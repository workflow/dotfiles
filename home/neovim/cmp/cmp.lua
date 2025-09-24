local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    -- Select the [n]ext item
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Select the [p]revious item
    ['<C-p>'] = cmp.mapping.select_prev_item(),

    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- Exit completion
    ['<C-e>'] = cmp.mapping.abort(),

    -- Accept ([y]es) the completion.
    --  This will auto-import if your LSP supports it.
    --  This will expand snippets if the LSP sent a snippet.
    -- Confirm or accept with Ctrl-y:
    -- - If nvim-cmp menu is visible: confirm the selection
    -- - Else if Copilot suggestion is visible: accept Copilot suggestion
    -- - Else: fallback (preserve native <C-y> or other mappings)
    ['<C-y>'] = cmp.mapping(function(fallback)
      local copilot_ok, copilot = pcall(require, 'copilot.suggestion')
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif copilot_ok and copilot.is_visible() then
        copilot.accept()
      else
        fallback()
      end
    end),
    ['<CR>'] = cmp.mapping.confirm { select = true },
    -- Accept also with Alt-l (Copilot default) without conflicts:
    -- - If nvim-cmp menu is visible: confirm the selection
    -- - Else if Copilot suggestion is visible: accept Copilot suggestion
    -- - Else: fallback (let the key do whatever it normally does)
    ['<M-l>'] = cmp.mapping(function(fallback)
      local copilot_ok, copilot = pcall(require, 'copilot.suggestion')
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif copilot_ok and copilot.is_visible() then
        copilot.accept()
      else
        fallback()
      end
    end),

    ['<C-Space>'] = cmp.mapping.complete {},
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          path = "[Path]",
          -- Specify the name for other sources you may have
        })[entry.source.name]

        return vim_item
      end
    })
  }
}

-- nvim-dadbod (SQL) setup
cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = 'vim-dadbod-completion' },
    { name = 'buffer' },
  },
})

-- Copoilot integration
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

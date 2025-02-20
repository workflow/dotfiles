{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  bookmarks-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "bookmarks-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "tomasky";
      repo = "bookmarks.nvim";
      rev = "12bf1b32990c49192ff6e0622ede2177ac836f11";
      sha256 = "DWtYdAioIrNLZg3nnkAXDo1MPZDbpA2F/KlKjS8kVls=";
    };
  };

  isLightTheme = osConfig.specialisation != {};

  lf-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lf-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "lmburns";
      repo = "lf.nvim";
      rev = "69ab1efcffee6928bf68ac9bd0c016464d9b2c8b";
      sha256 = "ys3kgXtgaE5OGyNYZ2PuqM9FDGjxfIjRgXBUDBVIjUM=";
    };
  };
in {
  imports =
    [
      ./avante # Cursor style AI IDE
      ./carbon
      ./chatgpt-nvim
      ./cmp
      ./copilot
      ./dadbod
      ./dap
      ./jdtls
      ./fidget # Sidebar notifications for LSP
      ./folds
      ./fugitive
      ./git-conflict-nvim
      ./lspsaga
      ./lualine
      ./mini-operators
      ./mini-icons
      ./mason-lsp
      ./nui # UI Components
      ./none-ls
      ./neotest
      ./notify # Pluggable Notifications
      ./oil
      ./plenary # LUA Functions
      ./rainbow-csv
      ./render-markdown
      ./telescope
      ./toggleterm
      ./treesitter
      ./overseer
    ]
    ++ lib.optionals isLightTheme [
      ./gruvbox
    ];

  programs.neovim = {
    enable = true;

    extraConfig = ''
      set mouse=a
      set number
      set clipboard=unnamedplus
      set ignorecase
      set smartcase

      " Defaults to be overwritten by vim-sleuth
      set tabstop=4
      set shiftwidth=4

      set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

      noremap h ;
      noremap ; l
      noremap l k
      noremap k j
      noremap j h
      noremap <C-w>; <C-w>l
      noremap <C-w>l <C-w>k
      noremap <C-w>k <C-w>j
      noremap <C-w>j <C-w>h
      noremap <C-w>: <C-w>L
      noremap <C-w>L <C-w>K
      noremap <C-w>K <C-w>J
      noremap <C-w>J <C-w>H

      " Vertical Awesomeness
      nnoremap <C-d> <C-d>zz
      nnoremap <C-u> <C-u>zz
      nnoremap G Gzz

      tnoremap <A-j> <C-\><C-N><C-w>h
      tnoremap <A-k> <C-\><C-N><C-w>j
      tnoremap <A-l> <C-\><C-N><C-w>k
      tnoremap <A-;> <C-\><C-N><C-w>l
      inoremap <A-j> <C-\><C-N><C-w>h
      inoremap <A-k> <C-\><C-N><C-w>j
      inoremap <A-l> <C-\><C-N><C-w>k
      inoremap <A-;> <C-\><C-N><C-w>l
      nnoremap <A-j> <C-w>h
      nnoremap <A-k> <C-w>j
      nnoremap <A-l> <C-w>k
      nnoremap <A-;> <C-w>l

      set shell=/etc/profiles/per-user/farlion/bin/fish

      let mapleader = ' '
      let maplocalleader = ','

      " Diff Settings
      set diffopt+=internal,algorithm:patience

      " Quickfix Lists
      nnoremap <silent><nowait> <C-j> :cprev<cr>
      nnoremap <silent><nowait> <C-;> :cnext<cr>

      " Saving
      nnoremap zz :update<CR>

      " Applying a macro to lines matching in visual selection
      " https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
      xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
      function! ExecuteMacroOverVisualRange()
        echo "@".getcmdline()
        execute ":'<,'>normal @".nr2char(getchar())
      endfunction

      " https://github.com/Saecki/crates.nvim
      lua require('crates').setup()

      " Fugitive
      " See https://github.com/tpope/vim-fugitive/issues/1510#issuecomment-660837020
      function! s:ftplugin_fugitive() abort
        nnoremap <buffer> <silent> cc :Git commit --quiet<CR>
        nnoremap <buffer> <silent> ca :Git commit --quiet --amend<CR>
        nnoremap <buffer> <silent> ce :Git commit --quiet --amend --no-edit<CR>
      endfunction
      augroup quiet_fugitive
        autocmd!
        autocmd FileType fugitive call s:ftplugin_fugitive()
      augroup END

      " Git-gutter
      " Use nerdfont icons as signs - inspired by https://github.com/JakobGM/dotfiles/blob/2fdc40ece4b36cf1f5143b5778c171c0859e119f/config/nvim/init.vim#L574-L579
      let g:gitgutter_sign_added = ''
      let g:gitgutter_sign_modified = ''
      let g:gitgutter_sign_removed = ''
      let g:gitgutter_sign_removed_first_line = ''
      let g:gitgutter_sign_modified_removed = ''
      " Simpler highlighting, looted from https://jakobgm.com/posts/vim/git-integration/
      let g:gitgutter_override_sign_column_highlight = 1
      highlight clear SignColumn

      " Vim Visual Multi
      let g:VM_custom_motions = {'h': ';', ';': 'l', 'l': 'k', 'k': 'j', 'j': 'h'}
      let g:VM_mouse_mappings = 1

      " Vim-test
      let test#strategy = "toggleterm"
      let g:test#rust#runner = 'cargonextest'
      nmap <silent> <leader>tt :TestNearest<CR>
      nmap <silent> <leader>tT :TestFile<CR>
      nmap <silent> <leader>ta :TestSuite<CR>
      nmap <silent> <leader>tl :TestLast<CR>
      nmap <silent> <leader>tg :TestVisit<CR>

      " Background light/dark toggling
      nmap <silent> <leader>i  :let &bg=(&bg=='light'?'dark':'light')<CR>

      " Sudo powers with :w!!
      cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
    '';

    extraLuaConfig = ''
      -- set termguicolors (24bit colors) to enable highlight groups
      vim.opt.termguicolors = true

      -- Wrapped lines should follow the indent
      vim.o.breakindent = true

      -- Remap for dealing with word wrap
      vim.keymap.set('n', 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
      vim.keymap.set('n', 'l', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

      -- Save undo history
      -- TODO: sync this if useful
      vim.o.undofile = true

      -- Timeout and Updatetime settings
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      vim.o.updatetime = 250

      -- Set completeopt to have a better completion experience
      vim.o.completeopt = 'menuone,noselect'

      -- Make <leader> faster
      vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

      -- Disable swapfiles
      vim.opt.swapfile = false

      -- Terminal Mode shortcuts
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { silent = true })
    '';

    extraPackages = with pkgs; [
      nixd # Nix Language Server
      prettierd # For yaml, html, json, markdown
      shellcheck
      shfmt
    ];

    plugins = with pkgs.vimPlugins; [
      argtextobj-vim
      {
        plugin = b64-nvim; # Base64 encoding/decoding
        config = ''
          local wk = require("which-key")
          wk.add(
            {
              {
                mode = { "v" },
                { "<leader>b", group = "[B]ase64" },
                { "<leader>bd", require("b64").decode, desc = "Base64 [D]ecode" },
                { "<leader>be", require("b64").decode, desc = "Base64 [E]ncode" },
              },
            }
          )
        '';
        type = "lua";
      }
      {
        plugin = bookmarks-nvim;
        config = ''
          require("bookmarks").setup({
            save_file = vim.fn.expand "$HOME/.bookmarks/bookmarks.nvim",
            on_attach = function(bufnr)
              local bm = require("bookmarks")
              local wk = require("which-key")
              wk.add(
                {
                  { "<leader>m", group = "Book[m]arks" },
                  { "<leader>ma", bm.bookmark_ann, desc = "Toggle [a]nnotation at current line" },
                  { "<leader>mc", bm.bookmark_clean, desc = "Clean all marks in local buffer" },
                  { "<leader>ml", bm.bookmark_list, desc = "Show marked file list in quickfix list" },
                  { "<leader>mm", bm.bookmark_toggle, desc = "Toggle [m]ark at current line" },
                  { "<leader>mn", bm.bookmark_next, desc = "Jump to next mark in local buffer" },
                  { "<leader>mp", bm.bookmark_prev, desc = "Jump to previous mark in local buffer" },
                }
              )
              require('telescope').load_extension('bookmarks')
            end
          })
        '';
        type = "lua";
      }
      {
        plugin = comment-nvim; # Commenting with gc
        config = ''
          require('Comment').setup()
        '';
        type = "lua";
      }
      {
        plugin = nvim-web-devicons;
        config = ''
        '';
        type = "lua";
      }
      {
        plugin = dressing-nvim; # Better UI for codeactions, code input etc...
        config = ''

        '';
        type = "lua";
      }
      {
        plugin = friendly-snippets; # User-friendly snippets, work with LuaSnip and other engines
      }
      {
        plugin = gitgutter; # Git diff in the gutter
        config = ''
          require('which-key').add
          {
            { "<leader>h", group = "Git [H]unk" },
            { "<leader>h_", hidden = true },
          }
        '';
        type = "lua";
      }
      vim-highlightedyank
      {
        plugin = indent-blankline-nvim; # Indentation guides
        config = ''
          require("ibl").setup({
            exclude = {
             filetypes = {"startify"},
            }
          })
          local hooks = require "ibl.hooks"
          hooks.register(hooks.type.ACTIVE, function(bufnr)
              return vim.tbl_contains(
                  { "yaml", "html", "svelte" },
                  vim.api.nvim_get_option_value("filetype", { buf = bufnr })
              )
          end)
          local wk = require("which-key")
          wk.add({
            { "[i", function() require("ibl").setup_buffer(0, {enabled = true}) end, desc = "Indentation Guides ON" },
            { "]i", function() require("ibl").setup_buffer(0, {enabled = false}) end, desc = "Indentation Guides OFF" },
          })
        '';
        type = "lua";
      }
      {
        plugin = lf-nvim;
        config = ''
          require("lf").setup({
            border = "rounded",
          })
          local wk = require("which-key")
          wk.add({
            {"<leader>fl", "<cmd>Lf<cr>" , desc = "[L]f" },
          })
        '';
        type = "lua";
      }
      {
        plugin = nvim-lspconfig; # Defaults for loads of LSP languages
      }
      {
        plugin = luasnip; # Snippet engine
      }
      {
        plugin = markdown-preview-nvim;
        config = ''
          local wk = require("which-key")
          wk.add({
            { "<leader>p", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown [P]review" },
          })
        '';
        type = "lua";
      }
      vim-numbertoggle
      {
        plugin = vim-qf; # Quickfix improvements
        config = '''';
      }
      vim-rooter
      vim-sleuth # Automatic shiftwidth and expandtab
      {
        plugin = vim-startify;
        config = ''
          let g:startify_change_to_dir = 0
          let g:startify_change_to_vcs_root = 1
          let g:startify_session_persistence = 1
          let g:startify_bookmarks = [ {'c': '~/nixos-config/home/neovim/default.nix'} ]
        '';
      }
      vim-surround
      {
        plugin = vim-suda; # Sudo support via :SudaRead and :SudaWrite
      }
      vim-test
      {
        plugin = text-case-nvim;
        config = ''
          require("textcase").setup({
            prefix = "ga",
          })
          require("telescope").load_extension("textcase")
          local wk = require("which-key")
          wk.add({
            { "ga.", "<Cmd>TextCaseOpenTelescope<CR>", desc = "Telescope" },
          })
        '';
        type = "lua";
      }
      vim-textobj-entire
      vim-toml
      {
        plugin = nvim-tree-lua;
        config = ''
          local function my_on_attach(bufnr)
            local api = require "nvim-tree.api"
            local function opts(desc)
              return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            -- default mappings
            api.config.mappings.default_on_attach(bufnr)
            -- custom mappings
            vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
          end
          require("nvim-tree").setup({
            on_attach = my_on_attach,
            disable_netrw = false, -- keeping netrw for :GBrowse from fugitive to work
            hijack_netrw = true, -- once no longer needed, check :he nvim-tree-netrw
          })
          local wk = require("which-key")
          wk.add(
            {
              { "<leader>f", group = "[F]iles(NvimTree)" },
              { "<leader>fc", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse NVimTree Node Recursively" },
              { "<leader>ff", "<cmd>NvimTreeFindFile<CR>", desc = "Move the cursor in the tree for the current buffer, opening folders if needed." },
              { "<leader>ft", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree Open/Close" },
            }
          )
          -- Autoclose, see https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
          local function tab_win_closed(winnr)
            local api = require"nvim-tree.api"
            local tabnr = vim.api.nvim_win_get_tabpage(winnr)
            local bufnr = vim.api.nvim_win_get_buf(winnr)
            local buf_info = vim.fn.getbufinfo(bufnr)[1]
            local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
            local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
            if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
              -- Close all nvim tree on :q
              if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
                api.tree.close()
              end
            else                                                      -- else closed buffer was normal buffer
              if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
                local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
                if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
                  vim.schedule(function ()
                    if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
                      vim.cmd "quit"                                        -- then close all of vim
                    else                                                  -- else there are more tabs open
                      vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
                    end
                  end)
                end
              end
            end
          end
          vim.api.nvim_create_autocmd("WinClosed", {
            callback = function ()
              local winnr = tonumber(vim.fn.expand("<amatch>"))
              vim.schedule_wrap(tab_win_closed(winnr))
            end,
            nested = true
          })
        '';
        type = "lua";
      }
      {
        plugin = trouble-nvim;
        config = ''
          local wk = require("which-key")
          wk.add(
            {
              { "<leader>x", group = "Trouble" },
              { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", desc = "[D]ocument Diagnostics" },
              { "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "[L]ocation List" },
              { "<leader>xq", "<cmd>Trouble quickfix<cr>", desc = "[Q]uickfix" },
              { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "[W]orkspace Diagnostics" },
              { "<leader>xx", "<cmd>Trouble<cr>", desc = "Toggle Trouble" },
            }
          )
          require("trouble").setup({
            action_keys = { -- key mappings for actions in the trouble list
              open_split = { "<c-s>" }, -- open buffer in new split
              open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
              previous = "l", -- previous item
              next = "k" -- next item
            },
          })
        '';
        type = "lua";
      }
      vim-unimpaired
      vim-visual-multi
      {
        plugin = which-key-nvim;
        config = ''
          require("which-key").setup {
          }
        '';
        type = "lua";
      }

      ## Language Specific Plugins
      crates-nvim
      dart-vim-plugin
      elm-vim
      vim-graphql
      vim-jsonnet
      {
        plugin = neodev-nvim; # Nvim LUA development
        config = ''
          require("neodev").setup({
            library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
          })
        '';
        type = "lua";
      }
      vim-flutter
      vim-helm
      vim-shellcheck
      vim-solidity
      vim-nix
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

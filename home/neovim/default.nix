{
  isImpermanent,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  isLightTheme = osConfig.specialisation != {};
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/nvim" # Data
      ".local/state/nvim" # state
      ".cache/nvim"
    ];
  };

  imports =
    [
      ./avante # Cursor style AI IDE
      ./bookmarks-nvim
      ./carbon
      ./cmp
      ./comment-nvim
      ./copilot
      ./dadbod
      ./dap
      ./diffview-nvim
      ./fidget # Sidebar notifications for LSP
      ./folds
      ./fugitive
      ./git-conflict-nvim
      ./gitsigns
      ./jdtls
      ./lspsaga
      ./lualine
      # Ensure devicons module is available before mocking it with mini.icons
      ./mason-lsp
      ./mini-icons
      ./mini-operators
      ./neotest
      ./noice # UI for commandline, messages and popupmenu
      ./none-ls
      ./notify # Pluggable Notifications
      ./nui # UI Components
      ./nvim-tree-lua # File Tree
      ./obsidian-nvim
      ./oil
      ./overseer
      ./plenary # LUA Functions
      ./rainbow-csv
      ./render-markdown
      ./telescope
      ./toggleterm
      ./treesitter
      ./trouble
      ./undotree
      ./vim-be-good # Vim Motion Learnenings
      ./vim-terraform
      ./vim-visual-multi
      ./web-devicons
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

      " Saving - use z. for centering the cursor instead
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

      " Vim Visual Multi
      let g:VM_custom_motions = {'h': ';', ';': 'l', 'l': 'k', 'k': 'j', 'j': 'h'}
      let g:VM_mouse_mappings = 1

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

      -- Faster exit shortcut
      vim.keymap.set({ 'n', 'v', 't' }, 'ZQ', ':qa!<CR>')

      -- Disable F1 as help shortcut
      vim.keymap.set({'n', 'i'}, '<F1>', '<Nop>', { noremap = true, silent = true })
    '';

    extraPackages = with pkgs; [
      nixd # Nix Language Server
      nodejs # For vim to have npm for Mason etc...
      curl # Required by copilot.lua runtime
      prettierd # For yaml, html, json, markdown
      pyright
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
        plugin = dressing-nvim; # Better UI for codeactions, code input etc...
        config = ''

        '';
        type = "lua";
      }
      {
        plugin = friendly-snippets; # User-friendly snippets, work with LuaSnip and other engines
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
      vim-unimpaired
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

{...}: {
  flake.modules.homeManager.neovim = {
    osConfig,
    pkgs,
    lib,
    ...
  }: let
    isLightTheme = osConfig.specialisation != {};
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/nvim"
        ".local/state/nvim"
        ".cache/nvim"
      ];
    };

    imports =
      [
        ./_avante
        ./_carbon
        ./_cmp
        ./_comment-nvim
        ./_dadbod
        ./_dap
        ./_diffview-nvim
        ./_fidget
        ./_folds
        ./_fugitive
        ./_git-conflict-nvim
        ./_gitsigns
        ./_jdtls
        ./_jj
        ./_lspsaga
        ./_lualine
        ./_mason-lsp
        ./_mini-icons
        ./_mini-operators
        ./_neotest
        ./_noice
        ./_conform
        ./_notify
        ./_nui
        ./_nvim-tree-lua
        ./_obsidian-nvim
        ./_oil
        ./_otter
        ./_overseer
        ./_plenary
        ./_rainbow-csv
        ./_render-markdown
        ./_telescope
        ./_toggleterm
        ./_treesitter
        ./_trouble
        ./_undotree
        ./_vim-be-good
        ./_vim-terraform
        ./_vim-visual-multi
        ./_web-devicons
        ./_yank-file-line
      ]
      ++ lib.optionals isLightTheme [./_gruvbox];

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
        xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
        function! ExecuteMacroOverVisualRange()
          echo "@".getcmdline()
          execute ":'<,'>normal @".nr2char(getchar())
        endfunction

        lua require('crates').setup()

        " Fugitive
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
        vim.opt.termguicolors = true
        vim.o.breakindent = true
        vim.keymap.set('n', 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        vim.keymap.set('n', 'l', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
        vim.o.undofile = true
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        vim.o.updatetime = 250
        vim.o.completeopt = 'menuone,noselect'
        vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
        vim.opt.swapfile = false
        vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { silent = true })
        vim.keymap.set({ 'n', 'v', 't' }, 'ZQ', ':qa!<CR>')
        vim.keymap.set({'n', 'i'}, '<F1>', '<Nop>', { noremap = true, silent = true })
      '';

      extraPackages = with pkgs; [
        harper
        nixd
        nodejs
        prettierd
        pyright
        shellcheck
        shfmt
      ];

      plugins = with pkgs.vimPlugins; [
        argtextobj-vim
        {
          plugin = b64-nvim;
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
          plugin = dressing-nvim;
          config = "";
          type = "lua";
        }
        {plugin = friendly-snippets;}
        vim-highlightedyank
        {
          plugin = indent-blankline-nvim;
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
        {plugin = nvim-lspconfig;}
        {plugin = luasnip;}
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
          plugin = vim-qf;
          config = "";
        }
        vim-rooter
        vim-sleuth
        {
          plugin = vim-startify;
          config = ''
            let g:startify_change_to_dir = 0
            let g:startify_change_to_vcs_root = 1
            let g:startify_session_persistence = 1
            let g:startify_bookmarks = [ {'c': '~/nixos-config/parts/features/dev/neovim/default.nix'} ]
          '';
        }
        vim-surround
        {plugin = vim-suda;}
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
        crates-nvim
        dart-vim-plugin
        elm-vim
        vim-graphql
        vim-jsonnet
        {
          plugin = neodev-nvim;
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
  };
}

{ pkgs, lib, ... }:
let
  vim-enmasse-branch = pkgs.nixpkgs-vim-enmasse-branch;

  nixpkgs-unstable = pkgs.unstable;
in
{
  programs.neovim = {
    enable = true;

    coc = {
      enable = false;
      pluginConfig = ''
        nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>
        " TextEdit might fail if hidden is not set.
        set hidden
        " Some servers have issues with backup files, see #649.
        set nobackup
        set nowritebackup
        " Give more space for displaying messages.
        set cmdheight=2
        " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
        " delays and poor user experience.
        set updatetime=100
        " Don't pass messages to |ins-completion-menu|.
        set shortmess+=c
        " Always show the signcolumn, otherwise it would shift the text each time
        " diagnostics appear/become resolved.
        if has("patch-8.1.1564")
          " Recently vim can merge signcolumn and number column into one
          set signcolumn=number
        else
          set signcolumn=yes
        endif
        " Use tab for trigger completion with characters ahead and navigate.
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config.
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction
        " Use <c-space> to trigger completion.
        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif
        " Make <CR> auto-select the first completion item and notify coc.nvim to
        " format on enter, <cr> could be remapped by other vim plugin
        inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
        " Use `[g` and `]g` to navigate diagnostics
        " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
        nmap <silent> [f <Plug>(coc-diagnostic-prev-error)
        nmap <silent> ]f <Plug>(coc-diagnostic-next)
        " GoTo code navigation.
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> ge <Plug>(coc-references)
        " Use K to show documentation in preview window.
        nnoremap <silent> K :call <SID>show_documentation()<CR>
        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction

        " Highlight the symbol and its references when holding the cursor.
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Symbol renaming.
        nmap <leader>rn <Plug>(coc-rename)

        " Run the Code Lens action on the current line.
        nmap <leader>cl  <Plug>(coc-codelens-action)

        " Formatting selected code.
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        " Remap keys for applying codeAction to the current buffer.
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Apply AutoFix to problem on the current line.
        nmap <leader>qf  <Plug>(coc-fix-current)
        " Map function and class text objects
        " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)
        " Remap <C-f> and <C-b> for scroll float windows/popups.
        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif
        " Use CTRL-S for selections ranges.
        " Requires 'textDocument/selectionRange' support of language server.
        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)
        " Add `:Format` command to format current buffer.
        command! -nargs=0 Format :call CocAction('format')
        " Add `:Fold` command to fold current buffer.
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        " Add `:OR` command for organize imports of the current buffer.
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
        " Add (Neo)Vim's native statusline support.
        " NOTE: Please see `:h coc-status` for integrations with external plugins that
        " provide custom statusline: lightline.vim, vim-airline.
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''\'''\')}
        " Mappings for CoCList
        " Show all diagnostics.
        nnoremap <silent><nowait> <localleader>a  :<C-u>CocList diagnostics<cr>
        " Show commands.
        nnoremap <silent><nowait> <localleader>c  :<C-u>CocList commands<cr>
        " Find symbol of current document.
        nnoremap <silent><nowait> <localleader>o  :<C-u>CocList outline<cr>
        " Search workspace symbols.
        nnoremap <silent><nowait> <localleader>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent><nowait> <leader>]  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent><nowait> <leader>[  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent><nowait> <localleader>p  :<C-u>CocListResume<CR>

        " CoC Highlight Box colors fix
        hi CocFloating ctermbg=240
      '';

      settings = {
        "languageserver" = {
          "nix" = {
            "command" = "rnix-lsp";
            "filetypes" = [ "nix" ];
          };
          "elmLS" = {
            "command" = "elm-language-server";
            "filetypes" = [ "elm" ];
            "rootPatterns" = [ "elm.json" ];
          };
          "golang" = {
            "command" = "gopls";
            "rootPatterns" = [ "go.mod" ];
            "filetypes" = [ "go" ];
          };
        };
        "codeLens.enable" = false;
        "coc.preferences.formatOnSaveFiletypes" = [
          "js"
          "ts"
          "typescript"
          "elm"
          "dart"
          "rust"
          "nix"
          "toml"
          "json"
          "jsonnet"
          "yaml"
          "sh"
          "python"
        ];

        "rust-analyzer.updates.prompt" = false;
        "rust-analyzer.check.allTargets" = true;
        "rust-analyzer.check.command" = "clippy";
        "rust-analyzer.check.extraArgs" = [
          "--tests"
          "--"
          "-D"
          "warnings"
          "-D"
          "clippy::all"
        ];
        "rust-analyzer.check.features" = "all";
        "rust-analyzer.lru.capacity" = 1280;

        "pyright.organizeimports.provider" = "isort";
        "python.formatting.provider" = "black";
        "python.linting.flake8Enabled" = true;
        "python.linting.mypyEnabled" = true;
        "python.linting.banditEnabled" = true;
        "python.analysis.typeCheckingMode" = "off";
        "pyright.testing.provider" = "pytest";

        "yaml.enable" = true;
        "yaml.format.enable" = true;
        "yaml.format.bracketSpacing" = true;
        "yaml.hover" = true;
        "yaml.completion" = true;
        "diagnostic-languageserver.filetypes" = {
          "markdown" = [ "write-good" "markdownlint" ];
          "sh" = "shellcheck";
          "yaml" = [ "yamllint" ];
        };
        "diagnostic-languageserver.formatFiletypes" = {
          "sh" = "shfmt";
        };

      };
    };

    extraConfig = ''
      set mouse=a
      set number
      set clipboard=unnamedplus
      set ignorecase
      set smartcase

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

      " Open up a simple file tree
      nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

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

      " Colorscheme
      autocmd vimenter * ++nested colorscheme gruvbox
      nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
      nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
      nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

      nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
      nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
      nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

      " Fugitive
      nnoremap <leader>gs :Git<CR>
      nnoremap <leader>gd :Gdiff<CR>
      nnoremap <leader>gdc :Gdiffsplit!<CR>
      nnoremap <leader>ge :Gedit<CR>
      nnoremap <leader>gr :Gread<CR>
      nnoremap <leader>gw :Gwrite<CR>
      nnoremap <leader>gm :GMove
      nnoremap <leader>gb :Git checkout -b<Space>
      nnoremap <leader>gc :Git checkout<Space>
      nnoremap <leader>gl :Gclog
      nnoremap <leader>g0l :0Gclog<CR>
      nnoremap <leader>gps :Git! push<CR>
      nnoremap <leader>gpf :Git! push --force-with-lease<CR>
      nnoremap <leader>gpl :Git! pull<CR>
      nnoremap <leader>gpn :Git! push -u origin HEAD<CR>
      nnoremap gj :diffget //2<CR>
      nnoremap gl :diffget //3<CR>
      " Fugitive-Gitlab
      let g:fugitive_gitlab_domains = ['https://git.datalabhell.at', 'https://gitlab.k8s.plansee-group.com']

      " Git-gutter
      " Use fontawesome icons as signs - stolen from https://github.com/JakobGM/dotfiles/blob/2fdc40ece4b36cf1f5143b5778c171c0859e119f/config/nvim/init.vim#L574-L579
      let g:gitgutter_sign_added = ''
      let g:gitgutter_sign_modified = ''
      let g:gitgutter_sign_removed = ''
      let g:gitgutter_sign_removed_first_line = ''
      let g:gitgutter_sign_modified_removed = ''
      " Simpler highlighting, stolen from https://jakobgm.com/posts/vim/git-integration/
      let g:gitgutter_override_sign_column_highlight = 1
      highlight clear SignColumn

      " Vim Visual Multi
      let g:VM_custom_motions = {'h': ';', ';': 'l', 'l': 'k', 'k': 'j', 'j': 'h'}
      let g:VM_mouse_mappings = 1

      " Leap
      lua require('leap').add_default_mappings()

      " Vim-test
      let test#strategy = "floaterm"
      let g:test#rust#runner = 'cargonextest'
      nmap <silent> <leader>tt :TestNearest<CR>
      nmap <silent> <leader>tT :TestFile<CR>
      nmap <silent> <leader>ta :TestSuite<CR>
      nmap <silent> <leader>tl :TestLast<CR>
      nmap <silent> <leader>tg :TestVisit<CR>

      " Background light/dark toggling
      nmap <silent> <leader>i  :let &bg=(&bg=='light'?'dark':'light')<CR>

      " Overseer
      lua require('overseer').setup()
    '';

    extraLuaConfig = ''
      -- Disable netrw as recommended by nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors (24bit colors) to enable highlight groups
      vim.opt.termguicolors = true

      -- Wrapped lines should follow the indent
      vim.o.breakindent = true

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

      -- Diagnostic keymaps
      local wk = require("which-key")
      wk.register({
        ["[d"] = { vim.diagnostic.goto_prev, "Prev [D]iagnostic" },
        ["]d"] = { vim.diagnostic.goto_next, "Next [D]iagnostic" },
        ["<localleader>d"] = { vim.diagnostic.open_float, "Open Floating [D]iagnostics" },
        ["<localleader>l"] = { vim.diagnostic.setloclist, "Open Diagnostics in [L]ocation List" },
        ["<localleader>q"] = { vim.diagnostic.setqflist, "Open Diagnostics in [Q]uickfix List" },
      })
    '';

    extraPackages = [
      pkgs.shfmt
      pkgs.rnix-lsp
    ];

    plugins = with pkgs.vimPlugins; [
      ## General Plugins
      argtextobj-vim
      # coc-css
      # coc-diagnostic # diagnostic-languageserver for linters like shellcheck and formatters like shfmt
      # coc-html
      # coc-java
      # coc-json
      # coc-julia
      # coc-nvim
      # coc-prettier
      # coc-pyright
      # {
      #   plugin = nixpkgs-unstable.vimPlugins.coc-rust-analyzer;
      #   config = ''
      #     nnoremap <silent><nowait> <localleader>t  :<C-u>CocCommand rust-analyzer.run<cr>
      #     nnoremap <silent><nowait> <localleader>e  :<C-u>CocCommand rust-analyzer.expandMacro<cr>
      #     nnoremap <silent><nowait> <localleader>l  :<C-u>CocCommand rust-analyzer.moveItemUp<cr>
      #     nnoremap <silent><nowait> <localleader>k  :<C-u>CocCommand rust-analyzer.moveItemDown<cr>
      #     nnoremap <silent><nowait> <localleader>r  :<C-u>CocCommand rust-analyzer.reloadWorkspace<cr>
      #     nnoremap <silent><nowait> <localleader>J  :<C-u>CocCommand rust-analyzer.joinLines<cr>
      #     nnoremap <silent><nowait> <leader>k  :<C-u>CocCommand rust-analyzer.openDocs<cr>
      #     xmap <leader>w  <Plug>(coc-codeaction-cursor)
      #     nmap <leader>w  <Plug>(coc-codeaction-cursor)
      #     xmap <leader>l  <Plug>(coc-codeaction-line)
      #     nmap <leader>l  <Plug>(coc-codeaction-line)
      #     xmap <leader>ct  :<C-u>CocCommand rust-analyzer.openCargoToml<cr>
      #     nmap <leader>ct  :<C-u>CocCommand rust-analyzer.openCargoToml<cr>
      #   '';
      # }
      # nixpkgs-unstable.vimPlugins.coc-sqlfluff
      # coc-tabnine
      # coc-tsserver
      # coc-vimlsp
      # coc-yaml
      vim-bookmarks
      {
        plugin = nixpkgs-unstable.vimPlugins.ChatGPT-nvim;
        config = ''
          require("chatgpt").setup({
            openai_params = {
              model = "gpt-4",
              frequency_penalty = 0,
              presence_penalty = 0,
              max_tokens = 800,
              temperature = 0,
              top_p = 1,
              n = 1,
            },
            openai_edit_params = {
              model = "gpt-4",
              temperature = 0,
              top_p = 1,
              n = 1,
            },
            popup_input = {
              submit = "<C-s>"
            }
          })
          local wk = require("which-key")
          wk.register({
            c = {
              name = "[C]hatGPT",
                c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
                e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
                g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
                t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
                k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
                d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
                a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
                o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
                s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
                f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
                x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
                r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
                l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
              },
          }, { prefix = "<leader>" })
        '';
        type = "lua";
      }
      {
        plugin = nvim-cmp; # Autocompletion 
        config = builtins.readFile ./cmp.lua;
        type = "lua";
      }
      {
        plugin = cmp_luasnip; # Autocompletion for luasnip
      }
      {
        plugin = nvim-cmp; # Autocompletion 
      }
      {
        plugin = cmp-nvim-lsp; # Autocompletion Additions
      }
      {
        plugin = cmp-path; # Path completions
      }
      {
        plugin = comment-nvim; # Commenting with gc
        config = ''
          require('Comment').setup()
        '';
        type = "lua";
      }
      nixpkgs-unstable.vimPlugins.copilot-vim
      {
        plugin = nvim-web-devicons;
        config = ''
        '';
        type = "lua";
      }
      vim-enmasse-branch.vimPlugins.vim-enmasse
      {
        plugin = vim-floaterm;
        config = ''
          let g:floaterm_keymap_toggle = '<Leader>t'
        '';
      }
      {
        plugin = fidget-nvim; # Status notifications for LSP
        config = ''
          require('fidget').setup()
        '';
        type = "lua";
      }
      {
        plugin = friendly-snippets; # User-friendly snippets, work with LuaSnip and other engines
      }
      {
        plugin = fugitive; # Git Fu
        config = ''
        require('which-key').register {
          ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        }
        '';
        type = "lua";
      }
      fugitive-gitlab-vim
      {
        plugin = gitgutter; # Git diff in the gutter
        config = ''
        require('which-key').register {
          ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        }
        '';
        type = "lua";
      }
      gruvbox
      vim-highlightedyank
      {
        plugin = indent-blankline-nvim; # Indentation guides
        config = ''
          require("ibl").setup()
          local wk = require("which-key")
          wk.register({
            ["[i"] = { function() require("ibl").setup_buffer(0, {enabled = true}) end, "Indentation Guides ON" },
            ["]i"] = { function() require("ibl").setup_buffer(0, {enabled = false}) end, "Indentation Guides OFF" },
          })
        '';
        type = "lua";
      }
      nixpkgs-unstable.vimPlugins.leap-nvim
      {
        plugin = lf-vim;
        config = ''
          vim.g.lf_map_keys = 0
          local wk = require("which-key")
          wk.register({
            ["<leader>fl"] = {"<cmd>Lf<cr>" , "[L]f" },
          })
        '';
        type = "lua";
      }
      {
        plugin = nvim-lspconfig; # Defaults for loads of LSP languages
      }
      {
        plugin = lualine-nvim;
        config = ''
          require('lualine').setup {
            options = {
              theme = 'gruvbox',
            },
          }
        '';
        type = "lua";
      }
      {
        plugin = luasnip; # Snippet engine
      }
      vim-numbertoggle
      {
        plugin = mason-nvim; # Automatically install LSP servers
        config = builtins.readFile ./lsp.lua;
        type = "lua";
      }
      {
        plugin = mason-lspconfig-nvim; # Automatically install LSP servers
      }
      nixpkgs-unstable.vimPlugins.overseer-nvim
      ReplaceWithRegister
      vim-rhubarb # github bindings for fugitive
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
        plugin = telescope-nvim;
        config = ''
          local builtin = require("telescope.builtin")
          local utils = require("telescope.utils")
          require("telescope").setup({
            defaults = {
              mappings = {
                i = {
                  ["<C-s>"] = require("telescope.actions").select_horizontal,
                },
                n = {
                  ["<C-s>"] = require("telescope.actions").select_horizontal,
                },
              },
            },
          })
          require("telescope").load_extension("fzf")
          local wk = require("which-key")
          wk.register({
            ["<space>"] = {
              name = "Find[ ](Telescope)",
                ["<space>"] = { "<cmd>Telescope git_files<CR>", "Version Controlled Files" },
                b = { "<cmd>Telescope buffers<CR>", "Buffers" },
                f = { "<cmd>Telescope find_files<CR>", "All Files" },
                g = { "<cmd>Telescope live_grep<CR>", "Grep" },
                h = { "<cmd>Telescope help_tags<CR>", "Help" },
                ["?"] = { "<cmd>Telescope keymaps<CR>", "Vim Keymap Cheatsheet" },
                ["."] = { function() builtin.find_files({ cwd = utils.buffer_dir() }) end, "Files in CWD" },
              },
          }, { prefix = "<leader>" })
        '';
        type = "lua";
      }
      {
        plugin = telescope-fzf-native-nvim;
      }
      vim-test
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
          end
          require("nvim-tree").setup({
            on_attach = my_on_attach,
          })
          local wk = require("which-key")
          wk.register({
            f = {
              name = "[F]iles(NvimTree)",
                c = { "<cmd>NvimTreeCollapse<CR>", "Collapse NVimTree Node Recursively" },
                f = { "<cmd>NvimTreeFindFile<CR>", "Move the cursor in the tree for the current buffer, opening folders if needed." },
                t = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree Open/Close" },
              },
          }, { prefix = "<leader>" })
        '';
        type = "lua";
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = ''
          -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
          vim.defer_fn(function()
            require('nvim-treesitter.configs').setup {
              auto_install = false,
              highlight = { enable = true },
              indent = { enable = true },
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = '<c-s>',
                  node_incremental = '<c-s>',
                  node_decremental = '<c-M-s>',
                },
              },
            }
          end, 0)
        '';
        type = "lua";
      }
      {
        plugin = nvim-treesitter-textobjects; # ip, ap, etc... from treesitter!
        config = ''
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
      julia-vim
      vim-jsonnet
      {
        plugin = neodev-nvim; # Nvim LUA development
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

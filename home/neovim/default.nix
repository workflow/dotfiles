{ pkgs, inputs, ... }:
let
  vim-enmasse-branch = pkgs.nixpkgs-vim-enmasse-branch;

  nixpkgs-unstable = pkgs.unstable;
in
{
  programs.neovim = {
    enable = true;

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
    '';

    extraLuaConfig = ''
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
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.nixpkgs-fmt
      inputs.nil.packages.x86_64-linux.default # Nix Language Server by Oxalica
    ];

    plugins = with pkgs.vimPlugins; [
      argtextobj-vim
      {
        plugin = b64-nvim; # Base64 encoding/decoding
        config = ''
          local wk = require("which-key")
          wk.register({
            b = {
              name = "[B]ase64",
              e = { require("b64").encode, "Base64 [E]ncode" },
              d = { require("b64").decode, "Base64 [D]ecode" },
            },
          }, { 
            prefix = "<leader>",
            mode = "v",
          })
        '';
        type = "lua";
      }
      vim-bookmarks
      {
        plugin = nixpkgs-unstable.vimPlugins.ChatGPT-nvim;
        config = ''
          require("chatgpt").setup({
            openai_params = {
              model = "gpt-4-turbo-preview",
              frequency_penalty = 0,
              presence_penalty = 0,
              max_tokens = 800,
              temperature = 0,
              top_p = 1,
              n = 1,
            },
            openai_edit_params = {
              model = "gpt-4-turbo-preview",
              temperature = 0,
              top_p = 1,
              n = 1,
            },
            popup_input = {
              submit = "<C-s>"
            },
            edit_with_instructions = {
              keymaps = {
                toggle_help = "<C-h>",
                use_output_as_input = "<C-x>",
              }
            },

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
        plugin = nvim-dap; # Debug Adapter Protocol
        config = builtins.readFile ./dap.lua;
        type = "lua";
      }
      {
        plugin = nvim-dap-ui; # DAP UI 
        config = ''
        '';
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
      {
        plugin = dressing-nvim; # Better UI for codeactions, code input etc...
        config = ''
          
        '';
        type = "lua";
      }
      vim-enmasse-branch.vimPlugins.vim-enmasse
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
          require("ibl").setup({
            enabled = false,
            exclude = {
             filetypes = {"startify"},
            }
          })
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
            extensions = {
              'fugitive',
              'mason',
              'nvim-tree',
              'toggleterm',
              'overseer',
              'trouble',
            }
          }
        '';
        type = "lua";
      }
      {
        plugin = luasnip; # Snippet engine
      }
      {
        plugin = markdown-preview-nvim;
        config = ''
          local wk = require("which-key")
          wk.register({
            ["<leader>m"] = { "<Plug>MarkdownPreviewToggle", "Toggle [M]arkdown Preview" },
          })
        '';
        type = "lua";
      }
      {
        plugin = nvim-notify;
        config = ''
          require('notify').setup()
        '';
        type = "lua";
      }
      {
        plugin = null-ls-nvim;
        config = ''
          local null_ls = require("null-ls")
          null_ls.setup({
            sources = { 
              null_ls.builtins.formatting.shfmt
            } 
          })
        '';
        type = "lua";
      }
      vim-numbertoggle
      {
        plugin = mason-nvim; # Automatically install LSP servers
        config = builtins.replaceStrings [ "LSP_PATH" ] [ "${inputs.nil.packages.x86_64-linux.default}/bin/nil" ] (builtins.readFile ./lsp.lua);
        type = "lua";
      }
      {
        plugin = mason-lspconfig-nvim; # Automatically install LSP servers
      }
      {
        plugin = overseer-nvim;
        config = ''
          require('overseer').setup({
            strategy = "toggleterm",
            templates = {
              "builtin",
              "user.gmailctl_apply",
              "user.nixos_rebuild_switch",
            },
          })
          local wk = require("which-key")
          wk.register({
            o = {
              name = "[O]verseer",
                r = { "<cmd>OverseerRun<CR>", "[R]un" },
                t = { "<cmd>OverseerToggle<CR>", "[T]oggle List" },
              },
          }, { prefix = "<leader>" })
        '';
        type = "lua";
      }
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
      {
        plugin = telescope-frecency-nvim;
        config = ''
          require("telescope").load_extension("frecency")
          local wk = require("which-key")
          wk.register({
            ["<space>"] = {
              name = "Find[ ](Telescope)",
                h = { "<Cmd>Telescope frecency workspace=CWD<CR>", "History (Frecency)" },
              },
          }, { prefix = "<leader>" })
        '';
        type = "lua";
      }
      vim-test
      vim-textobj-entire
      {
        plugin = toggleterm-nvim;
        config = ''
          require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = 'float',
          })
        '';
        type = "lua";
      }
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
          wk.register({
            f = {
              name = "[F]iles(NvimTree)",
                c = { "<cmd>NvimTreeCollapse<CR>", "Collapse NVimTree Node Recursively" },
                f = { "<cmd>NvimTreeFindFile<CR>", "Move the cursor in the tree for the current buffer, opening folders if needed." },
                t = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree Open/Close" },
              },
          }, { prefix = "<leader>" })
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
      {
        plugin = trouble-nvim;
        config = ''
          local wk = require("which-key")
          wk.register({
            x = {
              name = "Trouble",
              x = { "<cmd>Trouble<cr>", "Toggle Trouble" },
              w = { "<cmd>Trouble workspace_diagnostics<cr>", "[W]orkspace Diagnostics" },
              d = { "<cmd>Trouble document_diagnostics<cr>", "[D]ocument Diagnostics" },
              q = { "<cmd>Trouble quickfix<cr>", "[Q]uickfix" },
              l = { "<cmd>Trouble loclist<cr>", "[L]ocation List" },
            },
          }, { prefix = "<leader>" })
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
      julia-vim
      vim-jsonnet
      {
        plugin = neodev-nvim; # Nvim LUA development
        config = ''
          require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
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

  ## Overseer Templates
  home.file = {
    ".config/nvim/lua/overseer/template/user/gmailctl_apply.lua".source = ./overseer/gmailctl_apply.lua;
    ".config/nvim/lua/overseer/template/user/nixos_rebuild_switch.lua".source = ./overseer/nixos_rebuild_switch.lua;
  };
}

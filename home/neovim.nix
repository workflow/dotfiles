{ pkgs, lib, ... }:
let
  coc-flutter-branch = import sources.nixpkgs-vimplugins-coc-flutter { config.allowUnfree = true; };

  updated-copilot-vim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "github-copilot-vim";
    version = "1.4.2";

    src = pkgs.fetchgit {
      url = "https://github.com/github/copilot.vim";
      rev = "c2e75a3a7519c126c6fdb35984976df9ae13f564";
      hash = "sha256-V13La54aIb3hQNDE7BmOIIZWy7In5cG6kE0fti/wxVQ=";
    };
  };

  sources = import ../nix/sources.nix;

in
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      set mouse=a
      set number
      set clipboard=unnamedplus

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

      set shell=/home/farlion/.nix-profile/bin/fish

      let mapleader = ' '
      let maplocalleader = ','

      " COC Settings
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
      set updatetime=300
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

      " CoC Rust-Analyzer
      nnoremap <silent><nowait> <localleader>t  :<C-u>CocCommand rust-analyzer.run<cr>
      nnoremap <silent><nowait> <localleader>e  :<C-u>CocCommand rust-analyzer.expandMacro<cr>
      nnoremap <silent><nowait> <localleader>l  :<C-u>CocCommand rust-analyzer.moveItemUp<cr>
      nnoremap <silent><nowait> <localleader>k  :<C-u>CocCommand rust-analyzer.moveItemDown<cr>
      nnoremap <silent><nowait> <localleader>r  :<C-u>CocCommand rust-analyzer.reloadWorkspace<cr>
      nnoremap <silent><nowait> <localleader>J  :<C-u>CocCommand rust-analyzer.joinLines<cr>
      nnoremap <silent><nowait> <leader>k  :<C-u>CocCommand rust-analyzer.openDocs<cr>
      xmap <leader>w  <Plug>(coc-codeaction-cursor)
      nmap <leader>w  <Plug>(coc-codeaction-cursor)
      xmap <leader>l  <Plug>(coc-codeaction-line)
      nmap <leader>l  <Plug>(coc-codeaction-line)
      xmap <leader>ct  :<C-u>CocCommand rust-analyzer.openCargoToml<cr>
      nmap <leader>ct  :<C-u>CocCommand rust-analyzer.openCargoToml<cr>


      " FZF Settings
      nnoremap <C-p> :GFiles<cr>
      nnoremap <silent><nowait> <Leader><Space> :GFiles<cr>
      nnoremap <silent><nowait> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
      nnoremap <C-l> :Files<cr>
      nnoremap <silent><nowait> <C-g> :Rg!<cr>
      nnoremap <silent><nowait> <localleader>b :<C-u>Buf<cr>
      nnoremap <silent><nowait> <localleader>m :<C-u>History<cr>

      " Open up a simple file tree
      nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

      " Startify Settings
      let g:startify_change_to_dir = 0
      let g:startify_change_to_vcs_root = 1

      " Diff Settings
      set diffopt+=internal,algorithm:patience

      " NerdTree Settings
      nnoremap <silent><nowait> <leader>f :NERDTreeToggle<CR>
      nnoremap <silent><nowait> <leader>n :NERDTreeFind<CR>
      " Close if only NERDTree is open
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


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

      " LF Settings
      let g:lf_map_keys = 0
      nnoremap <silent><nowait> <localleader>f :Lf<CR>

      " Vimspector settings
      let g:vimspector_base_dir='/home/farlion/.vim/vimspector-config'
      let g:vimspector_enable_mappings = 'HUMAN'
      nmap <F8> <Plug>VimspectorToggleBreakpoint
      " mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
      " for normal mode - the word under the cursor
      nmap <Leader>di <Plug>VimspectorBalloonEval
      " for visual mode, the visually selected text
      xmap <Leader>di <Plug>VimspectorBalloonEval

      " Colorscheme
      autocmd vimenter * ++nested colorscheme gruvbox
      nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
      nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
      nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

      nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
      nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
      nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
    '';

    plugins = with pkgs.vimPlugins; [
      airline
      argtextobj-vim

      coc-css
      coc-diagnostic # diagnostic-languageserver for linters like shellcheck and formatters like shfmt
      coc-flutter-branch.vimPlugins.coc-flutter
      coc-html
      coc-json
      coc-nvim
      coc-pairs
      coc-prettier
      coc-rust-analyzer
      coc-tabnine
      coc-tsserver
      coc-vimlsp
      coc-yaml

      vim-commentary
      updated-copilot-vim
      crates-nvim
      dart-vim-plugin
      vim-devicons
      elm-vim
      vim-exchange
      vim-floaterm
      vim-flutter
      fzf-vim
      vim-graphql
      gruvbox
      vim-helm
      vim-highlightedyank
      vim-jsonnet
      lf-vim
      nerdtree
      vim-nix
      vim-numbertoggle
      ReplaceWithRegister
      vim-rooter
      vim-shellcheck
      vim-sleuth # Automatic shiftwidth and expandtab
      vim-solidity
      vimspector
      vim-startify
      vim-surround
      vim-textobj-entire
      vim-toml
      vim-unimpaired
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

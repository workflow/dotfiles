{ pkgs }:

let

  fzf-plugin = "${pkgs.fzf}/share/vim-plugins/fzf-${pkgs.fzf.version}";

in

''
  set nocompatible

  let g:haskell_enable_quantification = 1   " highlighting `forall`
  let g:haskell_enable_recursivedo = 1      " highlighting `mdo` and `rec`
  let g:haskell_enable_arrowsyntax = 1      " highlighting `proc`
  let g:haskell_enable_pattern_synonyms = 1 " highlighting `pattern`
  let g:haskell_enable_typeroles = 1        " highlighting type roles
  let g:haskell_enable_static_pointers = 1  " highlighting `static`
  let g:haskell_backpack = 1 " highlighting backpack keywords
  let g:haskell_indent_disable = 1

  set rtp+=~/.vim/bundle/Vundle.vim
  set rtp+=${fzf-plugin}

  call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'

  " plugins
  Plugin 'Raimondi/delimitMate'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'google/vim-searchindex'
  Plugin 'junegunn/fzf.vim'
  Plugin 'scrooloose/nerdcommenter'
  Plugin 'tpope/vim-surround'

  " filetypes
  Plugin 'LnL7/vim-nix'
  Plugin 'leafgarland/typescript-vim'
  Plugin 'neovimhaskell/haskell-vim'
  Plugin 'peitalin/vim-jsx-typescript'

  " themes & ui
  Plugin 'freeo/vim-kalisi'
  Plugin 'jonathanfilip/vim-lucius'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  call vundle#end()


  """""""""""""""""""""""""""""""""

  set lazyredraw
  set ttyfast
  set virtualedit=block
  set shortmess+=I
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set expandtab
  set hidden
  set backspace=2
  set wildmenu
  set wildmode=full
  set foldmethod=indent
  set foldlevel=99
  set hlsearch
  set autoread
  set showmatch
  set matchtime=4
  set timeoutlen=1000 ttimeoutlen=0
  set updatetime=100
  set number
  set splitbelow
  set splitright
  set noshowmode
  set noswapfile
  set wrap linebreak nolist
  set formatoptions+=r
  set incsearch
  set ignorecase
  set smartcase
  syntax on
  filetype on
  filetype plugin indent on
  filetype plugin on

  autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.hs,*.nix set tabstop=2
  autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.hs,*.nix set softtabstop=2
  autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.hs,*.nix set shiftwidth=2

  " jump to last position when opening file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif

  " Powerline setup
  set laststatus=2
  let g:airline_powerline_fonts=1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_skip_empty_sections = 1

  " NERDCommenter
  let g:NERDCustomDelimiters = {
      \ 'haskell': { 'left': '-- ', 'nested': 1, 'leftAlt': '{- ', 'rightAlt': ' -}', 'nestedAlt': 1 },
      \ 'cabal': { 'left': '-- ' },
      \ 'nix': { 'left': '# ' },
      \ 'c': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'cpp': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'javascript': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
  \ }
  execute "set <M-;>=\e;"
  nnoremap <M-;> :call NERDComment(0, "toggle")<CR>
  vnoremap <M-;> :call NERDComment(0, "toggle")<CR>

  " fzf
  let g:fzf_layout = { 'down': '~20%' }
  nnoremap <C-p> :Files<CR>
  nnoremap <leader>f :GFiles<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>s :Rg<CR>
  nnoremap <leader>/ :BLines<CR>
  nnoremap <leader>gc :Commits<CR>
  nnoremap <leader>gd :BCommits<CR>

  if has("persistent_undo")
      call system('mkdir -p ~/.vim/undo')
      set undodir=~/.vim/undo/
      set undofile
  endif

  let g:lucius_high_contrast = 1
  " let g:lucius_no_term_bg = 1

  if empty($TERM_LIGHT)
      let g:lucius_style = 'dark'
      set background=dark
      colorscheme lucius
      highlight Normal ctermbg=234
      highlight MatchParen cterm=reverse ctermfg=240
      highlight ColorColumn ctermbg=236
      highlight ExtraWhitespace ctermbg=88
      highlight LineNr ctermfg=241 ctermbg=NONE
      highlight VertSplit ctermfg=252 ctermbg=238
      highlight haskellBottom ctermfg=Red
      highlight haskellFail ctermfg=LightRed
      highlight haskellImportKeywords ctermfg=DarkCyan
      highlight haskellWhere ctermfg=DarkCyan
      highlight haskellLet ctermfg=DarkCyan
      highlight haskellDefault ctermfg=DarkCyan
      highlight haskellStatic ctermfg=DarkCyan
      highlight haskellConditional ctermfg=DarkCyan
      highlight haskellForall ctermfg=DarkCyan
      highlight haskellPatternKeyword ctermfg=DarkCyan
      highlight haskellTypeRoles ctermfg=DarkCyan
      let g:airline_theme='luna'
  else
      let g:lucius_style = 'light'
      set background=light
      colorscheme lucius
      highlight MatchParen ctermfg=240 ctermbg=152
      highlight ColorColumn ctermbg=252
      highlight ExtraWhitespace ctermbg=210
      let g:airline_theme='lucius'
  endif

  match ExtraWhitespace /\s\+$/
  highlight GitGutterAdd ctermbg=none
  highlight GitGutterChange ctermbg=none
  highlight GitGutterChangeDelete ctermbg=none
  highlight GitGutterDelete ctermbg=none
  let g:gitgutter_map_keys = 0

  " haskell
  function! JumpHaskellFunction(reverse)
      call search('\C^[[:alnum:]]\+\_s*::', a:reverse ? 'bW' : 'W')
  endfunction

  au FileType haskell nnoremap <buffer><silent> ]] :call JumpHaskellFunction(0)<CR>
  au FileType haskell nnoremap <buffer><silent> [[ :call JumpHaskellFunction(1)<CR>
  au FileType haskell nnoremap <buffer> gI gg /\cimport<CR><ESC>:noh<CR>

  if exists("+mouse")
      set mouse=a
  endif

  "split navigations
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>

  nnoremap Q <nop>
  noremap <silent> k gk
  noremap <silent> j gj

  "" various shortcuts
  noremap <C-n> :nohlsearch<CR>
  vnoremap > >gv
  vnoremap < <gv

  nnoremap <leader>q :bp<CR>
  nnoremap <leader>w :bn<CR>

  " lololol
  nmap ; :
  vmap ; :

  " trying that
  nmap , <leader>
''

{pkgs, ...}: {
  programs.neovim = {
    extraConfig = ''
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
      gruvbox
    ];
  };
}

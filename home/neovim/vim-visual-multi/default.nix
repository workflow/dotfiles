{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-visual-multi;
      config = ''
        let g:VM_maps = {}
        let g:VM_maps['Motion ,'] = ',,' " Removes conflict with , as LSP Leader
        let g:VM_maps['Goto Prev'] = '[[' " Removes conflict with vim-unimpaired
        let g:VM_maps['Goto Next'] = ']]' " Removes conflict with vim-unimpaired
      '';
    }
  ];
}

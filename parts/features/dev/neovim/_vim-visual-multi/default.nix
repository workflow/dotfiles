{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-visual-multi;
      type = "lua";
      config = ''
        vim.g.VM_maps = {
          ["Motion ,"] = ",,",  -- Removes conflict with , as LSP Leader
          ["Goto Prev"] = "[[",  -- Removes conflict with vim-unimpaired
          ["Goto Next"] = "]]",  -- Removes conflict with vim-unimpaired
        }
      '';
    }
  ];
}

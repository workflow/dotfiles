{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      # Intentionally put a minimal web-devicons plugin config BEFORE nvim-tree
      # so that nvim-tree sees a ready devicons provider (which is then mocked
      # by mini.icons). This avoids lazy-loading races in some plugin managers.
      plugin = pkgs.vimPlugins.nvim-web-devicons;
      config = ''
        -- Minimal setup; will be overridden by mini.icons.mock_nvim_web_devicons()
        require('nvim-web-devicons').setup({ color_icons = true, default = true })
      '';
      type = "lua";
    }
  ];
}

{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-fugitive;
      config = builtins.readFile ./fugitive.lua;
      type = "lua";
    }
    {
      plugin = vim-fubitive;
      type = "lua";
      config = ''
        vim.g.fubitive_domain_pattern = [[bitbucket-ssh\.plansee-group\.com]]
      '';
    }
    {
      plugin = fugitive-gitlab-vim;
      type = "lua";
      config = ''
        vim.g.fugitive_gitlab_domains = { "https://git.datalabhell.at", "https://gitlab.k8s.plansee-group.com" }
      '';
    }
    vim-rhubarb # github bindings for fugitive
  ];
}

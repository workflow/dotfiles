{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = fugitive;
      config = builtins.readFile ./fugitive.lua;
      type = "lua";
    }
    {
      plugin = vim-fubitive;
      config = ''
        let g:fubitive_domain_pattern = 'bitbucket-ssh\.plansee-group\.com'
      '';
    }
    {
      plugin = fugitive-gitlab-vim;
      config = ''
        let g:fugitive_gitlab_domains = ['https://git.datalabhell.at', 'https://gitlab.k8s.plansee-group.com']
      '';
    }
    vim-rhubarb # github bindings for fugitive
  ];

}

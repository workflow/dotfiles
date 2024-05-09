{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = fugitive;
      config = ''
        local function showFugitiveGit()
          if vim.fn.FugitiveHead() ~= ''' then
            vim.cmd [[
            Git
            " wincmd H  " Open Git window in vertical split
            " setlocal winfixwidth
            " vertical resize 31
            " setlocal winfixwidth
            setlocal nonumber
            setlocal norelativenumber
            ]]
          end
        end
        local function toggleFugitiveGit()
          if vim.fn.buflisted(vim.fn.bufname('fugitive:///*/.git//$')) ~= 0 then
            vim.cmd[[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]]
          else
            showFugitiveGit()
          end
        end
        vim.keymap.set('n', '<F3>', toggleFugitiveGit, opts)

        require('which-key').register {
          ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        }
      '';
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

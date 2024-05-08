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
    fugitive-gitlab-vim
    vim-rhubarb # github bindings for fugitive
  ];

}

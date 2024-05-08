{ pkgs, ... }:
let
  mini-operators = pkgs.vimUtils.buildVimPlugin {
    name = "mini-operators";
    src = pkgs.fetchFromGitHub {
      owner = "echasnovski";
      repo = "mini.operators";
      rev = "2edc808e32fbf3e0d4759bdef26a7a143a19f509";
      sha256 = "OFZyzhOTK+vUYejjdUMQoc905auZP/x6iqIZaS5KBVY=";
    };
  };
in
{

  programs.neovim.plugins = [
    {
      plugin = mini-operators;
      config = ''
        require('mini.operators').setup()
      '';
      type = "lua";
    }
  ];

}

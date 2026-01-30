{pkgs, ...}: {
  home.file = {
    ".config/nvim/lua/overseer/template/user/gmailctl_apply.lua".source = ./templates/gmailctl_apply.lua;

    ".config/nvim/lua/overseer/template/user/java_gradle.lua".source = ./templates/java_gradle/init.lua;

    ".config/nvim/lua/overseer/template/user/java_maven.lua".source = ./templates/java_maven/init.lua;

    ".config/nvim/lua/overseer/template/user/nixos_rebuild_switch.lua".source = ./templates/nixos_rebuild_switch.lua;
    ".config/nvim/lua/overseer/template/user/nixos_rebuild_boot.lua".source = ./templates/nixos_rebuild_boot.lua;
    ".config/nvim/lua/overseer/template/user/nixos_update_secrets.lua".source = ./templates/nixos_update_secrets.lua;
    ".config/nvim/lua/overseer/template/user/skaffold_dev.lua".source = ./templates/skaffold_dev.lua;
  };

  programs.neovim.plugins = [
    {
      config = builtins.readFile ./overseer.lua;
      plugin = pkgs.vimPlugins.overseer-nvim;
      runtime = {
        "lua/overseer_lib.lua".source = ./overseer_lib.lua;
      };
      type = "lua";
    }
  ];
}

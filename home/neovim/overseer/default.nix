{ pkgs, ... }:
{
  home.file = {
    ".config/nvim/lua/overseer/template/user/gmailctl_apply.lua".source = ./templates/gmailctl_apply.lua;

    ".config/nvim/lua/overseer/template/user/java_gradle/init.lua".source = ./templates/java_gradle/init.lua;
    ".config/nvim/lua/overseer/template/user/java_gradle/bootRun.lua".source = ./templates/java_gradle/bootRun.lua;
    ".config/nvim/lua/overseer/template/user/java_gradle/build.lua".source = ./templates/java_gradle/build.lua;
    ".config/nvim/lua/overseer/template/user/java_gradle/clean.lua".source = ./templates/java_gradle/clean.lua;
    ".config/nvim/lua/overseer/template/user/java_gradle/spotlessApply.lua".source = ./templates/java_gradle/spotlessApply.lua;
    ".config/nvim/lua/overseer/template/user/java_gradle/test.lua".source = ./templates/java_gradle/test.lua;

    ".config/nvim/lua/overseer/template/user/java_maven/init.lua".source = ./templates/java_maven/init.lua;
    ".config/nvim/lua/overseer/template/user/java_maven/clean_package.lua".source = ./templates/java_maven/clean_package.lua;
    ".config/nvim/lua/overseer/template/user/java_maven/test.lua".source = ./templates/java_maven/test.lua;

    ".config/nvim/lua/overseer/template/user/nixos_rebuild_switch.lua".source = ./templates/nixos_rebuild_switch.lua;
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

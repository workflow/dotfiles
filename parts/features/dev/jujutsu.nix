{...}: {
  flake.modules.homeManager.jujutsu = {pkgs, ...}: {
    programs.difftastic.enable = true;
    programs.jjui = {
      enable = true;
      package = pkgs.jjui;
    };
    programs.jujutsu = {
      enable = true;
      package = pkgs.unstable.jujutsu;
      settings = {
        remotes.origin.auto-track-bookmarks = "main";
        revsets.bookmark-advance-to = "@-";
        ui.diff-formatter = ["difft" "--color=always" "$left" "$right"];
        user = {
          email = "4farlion@gmail.com";
          name = "workflow";
        };
        signing = {
          backend = "gpg";
          key = "24575DB93F6CEC16";
          behavior = "own"; # sign commits you authored on modify
        };
        aliases = {
          bt = ["bookmark" "track"];
          c = ["commit"];
          gf = ["git" "fetch"];
          init = ["git" "init" "--colocate"];
          push = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            "jj bookmark advance && jj git push"
          ];
        };
      };
    };
  };
}

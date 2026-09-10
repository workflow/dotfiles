{...}: {
  flake.modules.homeManager.jujutsu = {
    config,
    pkgs,
    ...
  }: let
    # `jj done`: retire the current secondary workspace after its work landed
    # (direct fast-forward or merged PR) — see the script header. `herdr` is
    # picked up from the user PATH when --close-tab is used inside a tab.
    jjWorkspaceDone = pkgs.writeShellApplication {
      name = "jj-workspace-done";
      runtimeInputs = [config.programs.jujutsu.package pkgs.gh pkgs.coreutils pkgs.gnugrep pkgs.gnused];
      text = builtins.readFile ./scripts/jj-workspace-done.sh;
    };
  in {
    home.packages = [jjWorkspaceDone];
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
          done = ["util" "exec" "--" "jj-workspace-done"];
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

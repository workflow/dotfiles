{...}: {
  flake.modules.homeManager.jujutsu = {
    config,
    pkgs,
    ...
  }: let
    # `jj done`: retire the current secondary workspace (or with --all, every
    # one) after its work landed (direct fast-forward or merged PR) — see the
    # script header.
    jjWorkspaceDone = pkgs.callPackage ./_jj-workspace-done.nix {jujutsu = config.programs.jujutsu.package;};
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
        # DCO sign-off on every commit; agents are told not to add it themselves.
        templates.commit_trailers = "format_signed_off_by_trailer(self)";
        user = {
          email = "w0rkflow@pm.me";
          name = "workflow";
        };
        signing = {
          backend = "gpg";
          key = "24575DB93F6CEC16";
          behavior = "own"; # sign commits you authored on modify
        };
        # Sandboxed agents can't reach gpg-agent and commit unsigned; their
        # commits get signed here instead.
        git.sign-on-push = true;
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

  perSystem = {pkgs, ...}: {
    checks.jj-workspace-done = import ./_jj-workspace-done-test.nix {
      inherit pkgs;
      jjWorkspaceDone = pkgs.callPackage ./_jj-workspace-done.nix {};
    };
  };
}

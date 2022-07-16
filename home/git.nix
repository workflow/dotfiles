{ pkgs, ... }:
{
  programs.git =
    {
      aliases = {
        c = "commit";
        p = "push";
      };

      enable = true;

      extraConfig = {
        pull = {
          ff = "only";
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        rebase = {
          autoStash = true;
          autoSquash = true;
        };
        # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#git-protocol-error
        url = {
          "https://github.com" = {
            insteadOf = "git://github.com";
          };
        };
      };

      ignores = [ ".idea" "nohup.out" "mzdata" ".vimspector.json" ];

      userEmail = "4farlion@gmail.com";

      userName = "workflow";
    };

}

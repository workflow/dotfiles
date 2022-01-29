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
      };

      ignores = [ ".idea" "nohup.out" "mzdata" ];

      userEmail = "4farlion@gmail.com";

      userName = "workflow";
    };

}

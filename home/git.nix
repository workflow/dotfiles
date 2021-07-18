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
        };
        init = {
          defaultBranch = "main";
        };
      };

      ignores = [ ".idea" "nohup.out" ];

      userEmail = "4farlion@gmail.com";

      userName = "workflow";
    };

}

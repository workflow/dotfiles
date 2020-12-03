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
      };

      ignores = [ ".idea" "nohup.out" ];

      userEmail = "florian.peter@gmx.at";

      userName = "workflow";
    };

}

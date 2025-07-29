{
  inputs,
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    files = [
      ".local/state/comma-choices" # For ,
    ];
  };
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index = {
    enable = true;
  };

  # Use unstable comma to fix compatibility with nix-index 0.1.9
  programs.nix-index-database.comma.enable = false;
  home.packages = [
    pkgs.unstable.comma
  ];
}

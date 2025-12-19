{
  inputs,
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      ".local/state/comma-choices" # For ,
    ];
  };
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index = {
    enable = true;
  };
}

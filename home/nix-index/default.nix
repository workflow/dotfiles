{
  inputs,
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".local/state/comma-choices" # For ,
    ];
  };
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index = {
    enable = true;
  };

  programs.nix-index-database.comma.enable = true;
}

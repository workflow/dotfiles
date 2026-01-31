{config, lib, inputs, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.nix-index = {lib, ...}: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      files = [
        ".local/state/comma-choices"
      ];
    };

    programs.nix-index = {
      enable = true;
    };
  };
}

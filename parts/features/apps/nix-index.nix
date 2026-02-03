{inputs, ...}: {
  flake.modules.homeManager.nix-index = {lib, osConfig, ...}: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      files = [
        ".local/state/comma-choices" # For ,
      ];
    };

    programs.nix-index = {
      enable = true;
    };
  };
}

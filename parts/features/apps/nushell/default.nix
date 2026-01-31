{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.nushell = {
    lib,
    pkgs,
    ...
  }: let
    nushellWithClipboard = pkgs.unstable.nushell.overrideAttrs (oldAttrs: {
      cargoBuildFeatures = (oldAttrs.cargoBuildFeatures or []) ++ ["system-clipboard"];
    });
  in {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/nushell"
      ];
    };
    home.file = {
      ".config/nushell/.stignore" = {
        source = ./_syncthing/stignore-nushell;
      };
    };
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
      package = nushellWithClipboard;
    };
  };
}

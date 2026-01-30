{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.signal = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/Signal"
      ];
    };

    home.packages = [
      pkgs.signal-desktop
    ];
  };
}

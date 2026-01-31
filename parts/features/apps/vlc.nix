{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.vlc = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/vlc"
        ".local/share/vlc"
      ];
    };

    home.packages = [
      pkgs.vlc
    ];
  };
}

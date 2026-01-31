{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.cliphist = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".cache/cliphist"
      ];
    };

    services.cliphist = {
      enable = true;
    };

    systemd.user.services.cliphist = {
      Install.WantedBy = lib.mkForce ["niri.service"];
      Unit.Requires = ["niri.service"];
      Unit.After = ["niri.service"];
    };
    systemd.user.services.cliphist-images = {
      Install.WantedBy = lib.mkForce ["niri.service"];
      Unit.Requires = ["niri.service"];
      Unit.After = ["niri.service"];
    };

    home.packages = [pkgs.xdg-utils];
  };
}

{...}: {
  flake.modules.homeManager.cliphist = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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

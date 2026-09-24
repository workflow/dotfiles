{...}: {
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam.enable = true;

    # Proton games run under Xwayland, which xwayland-satellite exposes at
    # physical pixel size on fractionally scaled outputs. Wrapping a game in
    # gamescope (a native Wayland client) restores correct pointer mapping:
    #   gamescope -W 3840 -H 2160 -f -- %command%
    programs.steam.extraPackages = [pkgs.gamescope];
    programs.gamescope.enable = true;
  };

  flake.modules.homeManager.steam = {
    osConfig,
    lib,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/Steam"
        ".steam"
        ".config/Hades II"
      ];
    };
  };
}

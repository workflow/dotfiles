{...}: {
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam.enable = true;

    # Proton games run under Xwayland, which xwayland-satellite exposes at
    # physical pixel size on fractionally scaled outputs. Wrapping a game in
    # gamescope (a native Wayland client) restores correct pointer mapping:
    #   gamescope -W 3840 -H 2160 -f -- %command%
    programs.steam.extraPackages = [pkgs.gamescope];
    programs.gamescope.enable = true;

    # Steam pulls in 32-bit graphics → 32-bit numpy → 32-bit openblas, and
    # cache.nixos.org doesn't ship an i686 openblas binary for nixos-26.05.
    # Its checkPhase (xzcblat2) deadlocks on this CPU, so disable tests on the
    # i686 variant only. Drop this once Hydra publishes the binary again.
    nixpkgs.overlays = [
      (_: prev: {
        pkgsi686Linux = prev.pkgsi686Linux.extend (_: superI: {
          openblas = superI.openblas.overrideAttrs (_: {
            doCheck = false;
            doInstallCheck = false;
          });
        });
      })
    ];
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

{...}: {
  flake.modules.nixos.steam = {...}: {
    programs.steam.enable = true;

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

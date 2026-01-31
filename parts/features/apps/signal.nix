{...}: {
  flake.modules.homeManager.signal = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/Signal"
      ];
    };

    home.packages = [
      pkgs.signal-desktop
    ];
  };
}

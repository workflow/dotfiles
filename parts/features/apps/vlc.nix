{...}: {
  flake.modules.homeManager.vlc = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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

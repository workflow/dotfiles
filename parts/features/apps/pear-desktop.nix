{...}: {
  # Pear Desktop (formerly th-ch/youtube-music): YouTube Music wrapper whose
  # scrobbler plugin can target a custom ListenBrainz endpoint (koito on boar).
  flake.modules.homeManager.pear-desktop = {
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        # Electron userData dir: package.json productName is still
        # "YouTube Music" after the Pear Desktop rebrand
        ".config/YouTube Music"
      ];
    };

    # Unstable to stay close to upstream, which chases YT Music DOM changes
    home.packages = [
      pkgs.unstable.pear-desktop
    ];
  };
}

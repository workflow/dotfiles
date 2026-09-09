{...}: {
  flake.modules.homeManager.obsidian = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    # Electron picks the safeStorage backend from XDG_CURRENT_DESKTOP; niri is
    # unrecognized so it falls back to plain text. Force gnome-keyring via libsecret.
    obsidian = pkgs.symlinkJoin {
      name = "obsidian-keyring";
      paths = [pkgs.obsidian];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/obsidian --add-flags "--password-store=gnome-libsecret"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/obsidian"
        "Obsidian"
      ];
    };

    home.packages = [
      obsidian
    ];
  };
}

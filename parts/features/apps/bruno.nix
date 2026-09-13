# API client; collections are plain files kept in ~/code/bruno-collections (Forgejo repo)
{...}: {
  flake.modules.homeManager.bruno = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    # Same reason as obsidian.nix: Electron's safeStorage (used by Bruno for secret
    # environment variables) picks the backend from XDG_CURRENT_DESKTOP; niri is
    # unrecognised so it falls back to plain text. Force gnome-keyring via libsecret.
    bruno = pkgs.symlinkJoin {
      name = "bruno-keyring";
      # unstable: 4.0.0 vs 3.3.0 in 26.05 — drop the override once 26.05 catches up
      paths = [pkgs.unstable.bruno];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/bruno --add-flags "--password-store=gnome-libsecret"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/bruno" # Electron userData: preferences, opened collections, encrypted secrets
      ];
    };

    home.packages = [bruno];
  };
}

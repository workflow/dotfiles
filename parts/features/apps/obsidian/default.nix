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
        wrapProgram $out/bin/obsidian \
          --run '${lib.getExe clearStaleCache} "''${XDG_CONFIG_HOME:-$HOME/.config}/obsidian" ${pkgs.obsidian} || echo "obsidian-clear-stale-cache failed" >&2' \
          --add-flags "--password-store=gnome-libsecret"
      '';
    };

    # nixpkgs' electron 43.7.11 -> 43.8.3 reused the stale V8 code cache in the
    # profile, and the renderer died on `webFrame` with an empty window.
    # TODO: drop once electron invalidates its code cache across versions again,
    # see https://github.com/NixOS/nixpkgs/issues/578970
    clearStaleCache = pkgs.writeShellApplication {
      name = "obsidian-clear-stale-cache";
      runtimeInputs = [pkgs.coreutils];
      text = builtins.readFile ./_scripts/obsidian-clear-stale-cache.sh;
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

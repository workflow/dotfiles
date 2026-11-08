{...}: {
  flake.modules.homeManager.obsidian = {
    config,
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

    # Obsidian's self-updater drops newer app.asar builds into its config dir and
    # prefers them over the bundled one, but those target upstream's Electron, not
    # nixpkgs'. A mismatch (1.15.0 on electron 43.8.3) leaves an empty window.
    # TODO: drop this workaround (script + activation) once upstream handles it:
    # nixpkgs' obsidian patching out the self-updater, or home-manager's
    # programs.obsidian gaining an option for `updateDisabled` in obsidian.json.
    pinBundledApp = pkgs.writeShellApplication {
      name = "obsidian-pin-bundled-app";
      runtimeInputs = [pkgs.coreutils pkgs.jq];
      text = builtins.readFile ./_scripts/obsidian-pin-bundled-app.sh;
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

    home.activation.obsidianPinBundledApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${lib.getExe pinBundledApp} "${config.xdg.configHome}/obsidian"
    '';
  };
}

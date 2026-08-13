{...}: {
  flake.modules.homeManager.nushell = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: let
    # Custom nushell build with system-clipboard support for Ctrl+X keybinding
    nushellWithClipboard = pkgs.nushell.overrideAttrs (oldAttrs: {
      cargoBuildFeatures = (oldAttrs.cargoBuildFeatures or []) ++ ["system-clipboard"];
    });
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/nushell"
      ];
    };
    # Syncthing 2.x opens .stignore with O_NOFOLLOW, so this must be a real
    # file rather than a home-manager symlink into the store.
    home.activation.copyNushellStignore = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run install -D -m644 ${./_syncthing/stignore-nushell} ${config.home.homeDirectory}/.config/nushell/.stignore
    '';
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
      package = nushellWithClipboard;
    };
  };
}

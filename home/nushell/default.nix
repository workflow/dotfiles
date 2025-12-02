{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  # Custom nushell build with system-clipboard support for Ctrl+X keybinding
  nushellWithClipboard = pkgs.unstable.nushell.overrideAttrs (oldAttrs: {
    cargoBuildFeatures = (oldAttrs.cargoBuildFeatures or []) ++ ["system-clipboard"];
  });
in {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/nushell"
    ];
  };
  home.file = {
    ".config/nushell/.stignore" = {
      source = ./syncthing/stignore-nushell;
    };
  };
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    package = nushellWithClipboard;
  };
}

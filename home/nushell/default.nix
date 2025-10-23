{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
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
    package = pkgs.unstable.nushell;
  };
}

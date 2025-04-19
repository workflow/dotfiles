{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    files = [
      ".config/nushell/history.txt"
    ];
  };
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}

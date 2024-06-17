{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    package = pkgs.unstable.nushell;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}

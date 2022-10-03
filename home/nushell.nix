{ pkgs, lib, ... }:
{
  programs.nushell = {
    enable = true;
    package = pkgs.unstable.nushell;
    configFile.source = ../dotfiles/config.nu;
    envFile.source = ../dotfiles/env.nu;
  };
}

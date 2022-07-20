{ pkgs, lib, ... }:
{
  programs.nushell = {
    enable = true;
    configFile.source = ../dotfiles/config.nu;
    envFile.source = ../dotfiles/env.nu;
  };
}

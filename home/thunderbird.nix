{ config, lib, pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;

    profiles = {
      "main" = {
        isDefault = true;
      };
    };
  };
}

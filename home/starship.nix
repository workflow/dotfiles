{ config, lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      status = {
        disabled = false;
        symbol = "🔴 ";
      };
    };

  };
}

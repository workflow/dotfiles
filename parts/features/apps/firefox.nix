{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.firefox = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".mozilla/firefox"
        ".cache/mozilla/firefox"
      ];
    };

    programs.firefox = {
      enable = true;
      profiles = {
        main = {
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
          ];
          id = 0;
          isDefault = true;
        };
      };
    };
  };
}

{...}: {
  flake.modules.homeManager.firefox = {
    config,
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/mozilla/firefox"
        ".cache/mozilla/firefox"
      ];
    };

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
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

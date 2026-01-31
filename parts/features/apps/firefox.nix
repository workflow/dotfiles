{...}: {
  flake.modules.homeManager.firefox = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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

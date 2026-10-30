{...}: {
  flake.modules.homeManager.librewolf = {
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".librewolf"
        ".cache/librewolf"
      ];
    };

    programs.librewolf = {
      enable = true;
      profiles = {
        main = {
          # uBlock Origin ships with LibreWolf itself
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            darkreader
          ];
          settings = {
            "browser.shell.checkDefaultBrowser" = false;
          };
          id = 0;
          isDefault = true;
        };
      };
    };

    stylix.targets.librewolf.profileNames = ["main"];
  };
}

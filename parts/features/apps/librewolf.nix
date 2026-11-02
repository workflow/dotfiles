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
            # RFP forces light mode and a restricted font list on every site. FPP with all targets
            # keeps the same protections minus those two, which RFP cannot opt out of.
            "privacy.resistFingerprinting" = false;
            "privacy.fingerprintingProtection" = true;
            "privacy.fingerprintingProtection.overrides" = lib.concatStringsSep "," [
              "+AllTargets"
              "-CSSPrefersColorScheme"
              "-FontVisibilityBaseSystem"
              "-FontVisibilityLangPack"
              "-FontVisibilityRestrictGenerics"
            ];
          };
          id = 0;
          isDefault = true;
        };
      };
    };

    stylix.targets.librewolf = {
      profileNames = ["main"];
      # Stylix's pt-to-px conversion shrinks pages below Brave's 16px default; fontconfig already carries the Stylix families
      fonts.enable = false;
    };
  };
}

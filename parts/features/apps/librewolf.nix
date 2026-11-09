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
            # Stylix's former 12/11px values persist in prefs.js after its target is disabled; pin Brave's defaults so user.js wins
            "font.size.variable.x-western" = 16;
            "font.size.monospace.x-western" = 13;
            "font.name.serif.x-western" = "serif";
            "font.name.sans-serif.x-western" = "sans-serif";
            "font.name.monospace.x-western" = "monospace";
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

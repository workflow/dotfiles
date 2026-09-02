{...}: {
  flake.modules.homeManager.thunderbird = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    # No nixpkgs/NUR package exists for Thunderbird addons; hand-packaging the
    # ATN xpi is the upstream-blessed pattern (home-manager PR #6033).
    cardbook = pkgs.stdenvNoCC.mkDerivation rec {
      pname = "thunderbird-cardbook";
      version = "106.2";
      src = pkgs.fetchurl {
        url = "https://addons.thunderbird.net/thunderbird/downloads/file/1049108/cardbook-${version}-tb.xpi";
        hash = "sha256-kCf31+IRdxVpw4NGZAlHxopeyyjzQYBIK6PaX2guByA=";
      };
      dontUnpack = true;
      installPhase = ''
        install -Dm644 $src "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/cardbook@vigneau.philippe.xpi"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".thunderbird"
        ".cache/thunderbird"
      ];
    };

    programs.thunderbird = {
      enable = true;
      profiles = {
        "main" = {
          isDefault = true;
          extensions = [cardbook];
          settings = {
            # Auto-enable declaratively installed extensions
            "extensions.autoDisableScopes" = 0;
            # Defaults are declared in xdg.nix; the prompt can't write the
            # read-only mimeapps.list anyway, so it would nag every boot.
            "mail.shell.checkDefaultClient" = false;
            "calendar.alarms.showmissed" = false;
            "calendar.alarms.playsound" = false;
            "calendar.alarms.show" = false;
          };
        };
      };
    };
  };
}

{inputs, ...}: {
  flake.modules.homeManager.zen = {
    config,
    lib,
    osConfig,
    pkgs,
    ...
  }: let
    # Try to focus an existing Zen window on link open so the workspace comes to the foreground
    zenNiriOpen = pkgs.writeShellApplication {
      name = "zen-niri-open";
      runtimeInputs = [pkgs.niri pkgs.jq pkgs.coreutils config.programs.zen-browser.package];
      text = ''
        zen_id=$(niri msg --json windows | jq -r '.[] | select(.app_id == "zen-browser" or .app_id == "zen") | .id' | head -n1 || true)
        if [ -n "''${zen_id:-}" ]; then
          niri msg action focus-window --id "$zen_id" >/dev/null 2>&1 || true
        fi
        exec ${config.programs.zen-browser.package}/bin/zen "$@"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".zen"
      ];
    };

    home.packages = [zenNiriOpen];

    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      enable = true;
      profiles = {
        main = {
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            darkreader
            ublock-origin
          ];
        };
      };
    };

    stylix.targets.zen-browser.profileNames = ["main"];

    home.sessionVariables = {
      BROWSER = "${zenNiriOpen}/bin/zen-niri-open";
      DEFAULT_BROWSER = "${zenNiriOpen}/bin/zen-niri-open";
      MOZ_LEGACY_PROFILES = 1; # Temporary fix, see https://github.com/0xc000022070/zen-browser-flake/issues/179
    };
  };
}

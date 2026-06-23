{...}: {
  flake.modules.homeManager.bitwarden = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/Bitwarden"
      ];
    };

    home.packages = [
      # bitwarden-desktop dropped on 26.05: pulls electron_39 which is EOL/insecure
      # in nixpkgs. Re-add once nixpkgs ships an electron 40+ bump. Browser
      # extensions + bitwarden-cli cover the gap.
      pkgs.bitwarden-cli
    ];
  };
}

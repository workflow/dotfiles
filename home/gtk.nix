{ pkgs, ... }:
let
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  sources = import ../nix/sources.nix;

in
{
  gtk = {
    enable = true;
    font = {
      name = "Fira Code 9";
    };
    iconTheme = {
      name = "Pop";
      package = nixpkgs-unstable.pop-icon-theme;
    };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}

{
  lib,
  pkgs,
  ...
}: {
  specialisation.light.configuration = {
    environment.etc."specialisation".text = "light"; # this is for 'nh' to correctly recognise the specialisation
    stylix = {
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      polarity = lib.mkForce "light";
    };
    home-manager.users.farlion = {
      gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkForce false;
    };
  };
}

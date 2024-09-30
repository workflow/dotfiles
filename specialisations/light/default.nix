{
  config,
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
      # GTK
      gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkForce false;

      # QT
      qt.enable = lib.mkForce false;

      # i3
      xsession.windowManager.i3.config.bars = [
        (
          {
            command = "${pkgs.unstable.i3-gaps}/bin/i3bar";
            fonts = {
              names = ["Fira Code" "Font Awesome 6 Free"];
              size = 9.0;
            };
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }
          // config.specialisation.light.configuration.home-manager.users.farlion.lib.stylix.i3.bar
        )
      ];
      programs.i3status-rust.bars.default = {
        theme = lib.mkForce "ctp-latte";
      };
    };
  };
}

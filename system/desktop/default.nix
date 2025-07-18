{
  isImpermanent,
  lib,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    files = [
      "/etc/ly/save.ini" # Selected user and session
    ];
  };

  services.displayManager = {
    defaultSession = "niri";
    ly = {
      enable = true;
      settings = {
        animation = "doom";
        hide_borders = true;
        tty = 7; # Hopefully less logs flowing into the login screen, see https://codeberg.org/AnErrupTion/ly/issues/537
      };
    };
  };

  programs.niri.enable = true;

  programs.sway = {
    enable = true;
  };
}

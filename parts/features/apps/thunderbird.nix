{...}: {
  flake.modules.homeManager.thunderbird = {lib, osConfig, ...}: {
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
          settings = {
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

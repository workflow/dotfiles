{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.thunderbird = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
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
            "calendar.alarms.showmissed" = false;
            "calendar.alarms.playsound" = false;
            "calendar.alarms.show" = false;
          };
        };
      };
    };
  };
}

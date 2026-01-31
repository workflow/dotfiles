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
            "calendar.alarms.showmissed" = false;
            "calendar.alarms.playsound" = false;
            "calendar.alarms.show" = false;
          };
        };
      };
    };
  };
}

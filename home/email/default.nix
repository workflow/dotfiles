{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
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
}

{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".cache/tealdeer"
    ];
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };
}

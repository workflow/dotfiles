{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/discord"
    ];
  };

  programs.discord = {
    enable = true;
  };
}

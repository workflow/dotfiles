{
  config,
  lib,
  ...
}: {
  home-manager.users.farlion.home.persistence."/persist/home/farlion" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/share/org.localsend.localsend_app"
    ];
  };

  programs.localsend = {
    enable = true;
  };
}

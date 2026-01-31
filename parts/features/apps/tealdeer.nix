{...}: {
  flake.modules.homeManager.tealdeer = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".cache/tealdeer"];
    };

    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}

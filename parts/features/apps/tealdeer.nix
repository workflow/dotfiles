{config, lib, ...}: {
  flake.modules.homeManager.tealdeer = {...}: {
    home.persistence."/persist" = lib.mkIf config.dendrix.isImpermanent {
      directories = [".cache/tealdeer"];
    };

    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}

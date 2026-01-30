{config, lib, ...}: {
  flake.modules.homeManager.zoxide = {...}: {
    home.persistence."/persist" = lib.mkIf config.dendrix.isImpermanent {
      directories = [
        ".cache/zoxide"
        ".local/share/zoxide"
      ];
    };

    programs.zoxide.enable = true;
  };
}

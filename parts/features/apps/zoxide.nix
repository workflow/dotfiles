{...}: {
  flake.modules.homeManager.zoxide = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".cache/zoxide"
        ".local/share/zoxide"
      ];
    };

    programs.zoxide.enable = true;
  };
}

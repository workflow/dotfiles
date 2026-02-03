{...}: {
  flake.modules.homeManager.zoxide = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".cache/zoxide" # Some stuff for nushell
        ".local/share/zoxide" # Zoxide DB
      ];
    };

    programs.zoxide.enable = true;
  };
}

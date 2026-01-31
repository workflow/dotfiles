{...}: {
  flake.modules.nixos.localsend = {...}: {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.localsend = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/org.localsend.localsend_app"];
    };
  };
}

{...}: {
  flake.modules.homeManager.rust = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".cargo"];
    };
  };
}

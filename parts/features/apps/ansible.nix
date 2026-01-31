{...}: {
  flake.modules.homeManager.ansible = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".ansible"];
    };
  };
}

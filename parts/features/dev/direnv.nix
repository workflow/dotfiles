{...}: {
  flake.modules.homeManager.direnv = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/direnv"];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.strict_env = true;
    };
  };
}

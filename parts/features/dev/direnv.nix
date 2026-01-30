{config, lib, ...}: {
  flake.modules.homeManager.direnv = {...}: {
    home.persistence."/persist" = lib.mkIf config.dendrix.isImpermanent {
      directories = [".local/share/direnv"];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.strict_env = true;
    };
  };
}

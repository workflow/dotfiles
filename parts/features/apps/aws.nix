{...}: {
  flake.modules.homeManager.aws = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".aws"];
    };

    home.packages = [pkgs.awscli2];
  };
}

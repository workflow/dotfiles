{...}: {
  flake.modules.homeManager.codex = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".codex"];
    };

    home.packages = [pkgs.unstable.codex];
  };
}

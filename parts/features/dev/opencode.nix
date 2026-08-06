{...}: {
  flake.modules.homeManager.opencode = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/opencode"];
    };

    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
    };
  };
}

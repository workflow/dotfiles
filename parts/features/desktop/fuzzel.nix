{...}: {
  flake.modules.homeManager.fuzzel = {pkgs, ...}: {
    programs.fuzzel = {
      enable = true;
      package = pkgs.unstable.fuzzel;
    };
  };
}

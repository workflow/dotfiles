{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    package = pkgs.unstable.fuzzel;
  };
}

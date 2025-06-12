{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    package = pkgs.unstable.fuzzel;
    settings = {
      main = {
        icon-theme = "Papirus";
      };
    };
  };
}

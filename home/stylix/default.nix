{pkgs, ...}: {
  home.packages = [
    pkgs.papirus-icon-theme
  ];
  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
    targets = {
      firefox = {
        profileNames = ["main"];
      };
      neovim.enable = false;
    };
  };
}

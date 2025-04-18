{pkgs, ...}: {
  home.packages = [
    pkgs.papirus-icon-theme
  ];
  stylix = {
    targets = {
      firefox = {
        profileNames = ["main"];
      };
      neovim.enable = false;
    };
  };
}

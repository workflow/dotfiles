{pkgs, ...}: {
  home.file = {
    ".config/pulsemixer.cfg".source = ./pulsemixer.cfg;
  };

  home.packages = [
    pkgs.pulsemixer
  ];
}

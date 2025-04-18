{pkgs, ...}: {
  home.packages = [
    pkgs.pulsemixer
  ];

  home.file = {
    ".config/pulsemixer.cfg".source = ./pulsemixer.cfg;
  };
}

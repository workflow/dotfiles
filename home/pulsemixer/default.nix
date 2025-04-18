{pkgs, ...}: {
  home.packages = [
    pkgs.pulsemixer
  ];

  home.files = {
    ".config/pulsemixer.cfg".source = ./pulsemixer.cfg;
  };
}

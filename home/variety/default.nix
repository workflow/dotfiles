{pkgs, ...}: {
  home.packages = [
    pkgs.variety
  ];

  home.file = {
    ".config/variety/variety.conf".source = ./variety.conf;
  };
}

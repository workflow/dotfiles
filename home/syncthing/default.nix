{pkgs, ...}: {
  home.packages = [
    pkgs.syncthingtray-minimal
  ];

  services.syncthing = {
    enable = true;
  };
}

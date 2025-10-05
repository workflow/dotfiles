{pkgs, ...}: {
  home.packages = with pkgs; [
    hwatch
  ];
}

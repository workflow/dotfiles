{pkgs, ...}: {
  home.packages = with pkgs; [
    hoppscotch
  ];
}

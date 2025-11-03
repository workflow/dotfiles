{pkgs, ...}: {
  home.packages = with pkgs; [
    jjui
  ];
  programs.jujutsu = {
    enable = true;
  };
}

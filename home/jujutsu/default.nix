{pkgs, ...}: {
  home.packages = with pkgs; [
    jjui
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "4farlion@gmail.com";
        name = "workflow";
      };
    };
  };
}

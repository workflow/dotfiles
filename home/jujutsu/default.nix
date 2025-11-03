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
      signing = {
        backend = "gpg";
        key = "24575DB93F6CEC16";
        behavior = "own"; # sign commits you authored on modify
      };
    };
  };
}

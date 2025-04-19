{pkgs, ...}: {
  home.packages = [
    pkgs.postgresql
  ];
  home.file.".psqlrc".source = ./psqlrc;
}

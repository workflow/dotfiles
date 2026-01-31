{...}: {
  flake.modules.homeManager.psql = {pkgs, ...}: {
    home.packages = [pkgs.postgresql];
    home.file.".psqlrc".source = ./_psqlrc;
  };
}

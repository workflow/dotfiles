# Wallpaper Switcher/Randomizer with Quotes
{...}: {
  flake.modules.homeManager.variety = {pkgs, ...}: {
    home.packages = [pkgs.variety];
    home.file.".config/variety/variety.conf".source = ./_variety.conf;
  };
}

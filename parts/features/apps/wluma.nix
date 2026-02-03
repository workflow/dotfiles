# Automatic brightness adjustment based on screen contents and ALS
{...}: {
  flake.modules.homeManager.wluma = {lib, osConfig, ...}: {
    services.wluma = lib.mkIf osConfig.dendrix.isLaptop {
      enable = true;
    };
  };
}

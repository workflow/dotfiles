{pkgs, ...}: {
  services.cliphist = {
    enable = true;
    systemdTarget = "sway-session.target";
  };

  home.packages = [pkgs.xdg-utils]; # For image copy/pasting
}

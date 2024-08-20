{pkgs, ...}: {
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}

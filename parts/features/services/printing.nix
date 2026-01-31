{...}: {
  flake.modules.nixos.printing = {pkgs, ...}: {
    services.printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.hplip
      ];
      listenAddresses = ["127.0.0.1:631"];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}

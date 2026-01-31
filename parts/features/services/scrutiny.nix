{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.scrutiny = {lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        {
          directory = "/var/lib/private";
          mode = "0700";
        }
        "/var/lib/private/scrutiny"
      ];
    };

    services.scrutiny = {
      enable = true;
      settings.web.listen.port = 8081;
    };

    systemd.services.scrutiny.enableStrictShellChecks = false;

    systemd.tmpfiles.rules = [
      "d /var/lib/private 0700 root root -"
    ];
  };
}

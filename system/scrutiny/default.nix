{
  lib,
  isImpermanent,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
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
}

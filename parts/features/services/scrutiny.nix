# Scrutiny - S.M.A.R.T. disk health monitoring dashboard.
# Web UI on port 8081.
{...}: {
  flake.modules.nixos.scrutiny = {config, lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
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
      # Bind the dashboard to loopback only; reach it via tailscale serve, not the LAN.
      settings.web.listen.host = "127.0.0.1";
    };

    # Scrutiny auto-enables influxdb2 as its backend; keep it off the network too.
    services.influxdb2.settings.http-bind-address = "127.0.0.1:8086";

    systemd.tmpfiles.rules = [
      "d /var/lib/private 0700 root root -"
    ];
  };
}

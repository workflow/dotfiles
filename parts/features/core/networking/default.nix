{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.networking = {
    lib,
    pkgs,
    ...
  }: let
    tailscale-ip = pkgs.writers.writeBashBin "tailscale-ip" (
      builtins.readFile ./_scripts/tailscale-ip.sh
    );
  in {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/tailscale"
        "/var/lib/NetworkManager"
      ];
    };

    environment.systemPackages = [
      pkgs.pwru
      tailscale-ip
    ];

    networking.firewall = {
      logReversePathDrops = true;
      logRefusedPackets = true;
    };

    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      useRoutingFeatures = "client";
    };

    environment.etc.hosts.mode = "0644";

    networking.firewall.allowedTCPPorts = [22000];
    networking.firewall.allowedUDPPorts = [22000 21027];

    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    networking.networkmanager.enable = true;
    users.users.farlion.extraGroups = ["networkmanager"];

    networking.dhcpcd.enable = false;

    programs.captive-browser = lib.mkIf cfg.dendrix.isLaptop {
      enable = true;
      bindInterface = false;
    };

    systemd.network.wait-online.anyInterface = true;
  };

  flake.modules.homeManager.networking = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".config/tailscale"];
    };
  };
}

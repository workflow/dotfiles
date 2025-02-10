{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.pwru # eBPF-based linux kernel networking debugger
  ];

  networking.firewall = {
    # if packets are dropped, they will show up in dmesg
    logReversePathDrops = true;
    logRefusedPackets = true;
    # logRefusedUnicastsOnly = false;
  };

  # Tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Allow for dynamic hosts file override (by root)
  environment.etc.hosts.mode = "0644";

  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing TCP
  ];

  networking.firewall.allowedUDPPorts = [
    5901 # RMview Remarkable 2 Screensharing
    22000 # Syncthing QUIC
    21027 # Syncthing discovery broadcasts on IPv4 and multicasts on IPv6
  ];

  networking.networkmanager = {
    enable = true;
  };

  # Prevent IPv6 leaks when using VPNs
  networking.enableIPv6 = false;

  # Disabling DHCPCD in favor of NetworkManager
  networking.dhcpcd.enable = false;
  # Only wait for a single interface to come up
  systemd.network.wait-online.anyInterface = true;

  # MacGyver
  systemd.services.macgyver = {
    description = "MacGyver";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${(pkgs.python3.withPackages (ps: with ps; [json5]))}/bin/python /home/farlion/code/dlh/common_scripts/setup_tools/sshforwarding/setup_forwarding.py --config_path /home/farlion/code/dlh/common_scripts/setup_tools/sshforwarding/";
      Environment = "PATH=/run/current-system/sw/bin:$PATH";
      Restart = "always";
      RestartSec = 30;
      User = "root";
      Group = "root";
      KillSignal = "SIGINT";
    };
  };

  programs.wireshark.enable = true;
  users.users.farlion.extraGroups = ["wireshark"];
}

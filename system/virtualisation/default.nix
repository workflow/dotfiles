{
  config,
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/containers" # Podman
      "/var/lib/docker"
      "/var/lib/libvirt" # Virt-Manager
    ];
  };
  home-manager.users.farlion.home.persistence."/persist/home/farlion" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/share/containers" # Podman (userspace)
    ];
  };

  environment.systemPackages = [
    pkgs.virt-manager # Desktop user interface for managing virtual machines
  ];
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # Attach to resolved instead of using default Docker DNS servers
      dns = ["172.17.0.1"];
      # Have containers listen on localhost instead of 0.0.0.0,
      # see https://github.com/NixOS/nixpkgs/issues/111852#issuecomment-1954656069
      ip = "127.0.0.1";
    };
  };
  # Allow connecting to resolved DNS from inside Docker containers
  networking.firewall.interfaces.docker0.allowedTCPPorts = [53];
  networking.firewall.interfaces.docker0.allowedUDPPorts = [53];

  # Allow DNS on all Docker bridge interfaces (br-*)
  networking.firewall.extraCommands = ''
    # Allow DNS (port 53) on all Docker bridge interfaces
    for iface in $(ip link show | grep -o 'br-[a-f0-9]\{12\}' || true); do
      if [ -n "$iface" ]; then
        iptables -A nixos-fw -i "$iface" -p tcp --dport 53 -j ACCEPT
        iptables -A nixos-fw -i "$iface" -p udp --dport 53 -j ACCEPT
      fi
    done

    # Allow Docker containers to reach Tailscale networks
    # Insert rule before Tailscale's DROP rule to allow Docker -> Tailscale traffic
    iptables -I ts-forward 3 -s 172.17.0.0/16 -d 100.64.0.0/10 -j ACCEPT
    iptables -I ts-forward 3 -s 172.17.0.0/16 -d 100.100.0.0/16 -j ACCEPT
    iptables -I ts-forward 3 -s 172.18.0.0/16 -d 100.64.0.0/10 -j ACCEPT
    iptables -I ts-forward 3 -s 172.18.0.0/16 -d 100.100.0.0/16 -j ACCEPT

    # Fix MTU issues for Docker -> Tailscale traffic
    # Clamp MSS to account for Tailscale's MTU of 1280
    # Without this, HTTPS connections from Docker to Tailscale frequently fail.
    iptables -t mangle -A FORWARD -s 172.17.0.0/16 -d 100.64.0.0/10 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    iptables -t mangle -A FORWARD -s 172.18.0.0/16 -d 100.64.0.0/10 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    iptables -t mangle -A FORWARD -s 172.17.0.0/16 -d 100.100.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    iptables -t mangle -A FORWARD -s 172.18.0.0/16 -d 100.100.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
  '';

  virtualisation.libvirtd.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  users.users.farlion.extraGroups = ["libvirtd" "kvm" "docker"];
}

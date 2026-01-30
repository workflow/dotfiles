{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.virtualisation = {
    config,
    lib,
    pkgs,
    ...
  }: let
    benchmark-containers = pkgs.writeShellApplication {
      name = "benchmark-containers";
      runtimeInputs = with pkgs; [docker podman coreutils];
      text = builtins.readFile ./_scripts/benchmark-containers.sh;
    };
    benchmark-heavy-containers = pkgs.writeShellApplication {
      name = "benchmark-heavy-containers";
      runtimeInputs = with pkgs; [docker podman coreutils];
      text = builtins.readFile ./_scripts/benchmark-heavy-containers.sh;
    };
    reset-container-state = pkgs.writeShellApplication {
      name = "reset-container-state";
      runtimeInputs = with pkgs; [docker podman coreutils systemd];
      text = builtins.readFile ./_scripts/reset-container-state.sh;
    };
  in {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        "/var/lib/containers"
        "/var/lib/docker"
        "/var/lib/libvirt"
      ];
    };
    home-manager.users.farlion.home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/share/containers"
      ];
    };

    environment.systemPackages = [
      pkgs.podman-compose
      pkgs.virt-manager
      benchmark-containers
      benchmark-heavy-containers
      reset-container-state
    ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
      daemon.settings = {
        dns = ["172.17.0.1"];
        ip = "127.0.0.1";
        ipv6 = false;
        ip6tables = false;
        iptables = true;
      };
    };

    networking.firewall.interfaces.docker0.allowedTCPPorts = [53];
    networking.firewall.interfaces.docker0.allowedUDPPorts = [53];

    networking.firewall.extraCommands = ''
      for iface in $(${pkgs.iproute2}/bin/ip link show | grep -o 'br-[a-f0-9]\{12\}' || true); do
        if [ -n "$iface" ]; then
          iptables -I nixos-fw 1 -i "$iface" -p tcp --dport 53 -j ACCEPT
          iptables -I nixos-fw 1 -i "$iface" -p udp --dport 53 -j ACCEPT
        fi
      done

      iptables -I FORWARD 1 -s 172.16.0.0/12 -d 172.16.0.0/12 -p tcp --dport 53 -j ACCEPT
      iptables -I FORWARD 1 -s 172.16.0.0/12 -d 172.16.0.0/12 -p udp --dport 53 -j ACCEPT

      iptables -t mangle -A FORWARD -s 172.17.0.0/16 -d 100.64.0.0/10 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      iptables -t mangle -A FORWARD -s 172.18.0.0/16 -d 100.64.0.0/10 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      iptables -t mangle -A FORWARD -s 172.17.0.0/16 -d 100.100.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      iptables -t mangle -A FORWARD -s 172.18.0.0/16 -d 100.100.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    '';

    virtualisation.libvirtd.enable = true;

    virtualisation.podman = {
      enable = true;
    };

    virtualisation.containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        options = {
          pull_options = {
            enable_partial_images = "true";
            use_hard_links = "false";
            ostree_repos = "";
          };
          overlay = {
            mountopt = "nodev,metacopy=on";
            force_mask = "0000";
          };
        };
      };
    };

    users.users.farlion.extraGroups = ["libvirtd" "kvm" "docker"];
  };
}

{...}: {
  flake.modules.nixos.kind-killer = {pkgs, ...}: {
    systemd.services.kind-killer = {
      description = "Kill kind cluster on shutdown";
      after = ["docker.service"]; # Ensures docker is still running when trying to delete the cluster, since systemd reverses the ordering during shutdown
      requires = ["docker.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Environment = "PATH=$PATH:/run/current-system/sw/bin";
        ExecStart = "${pkgs.coreutils}/bin/sleep infinity";
        ExecStop = "${pkgs.kind}/bin/kind delete cluster";
      };
    };
  };
}

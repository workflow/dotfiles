{...}: {
  flake.modules.nixos.kind-killer = {pkgs, ...}: {
    systemd.services.kind-killer = {
      description = "Kill kind cluster on shutdown";
      after = ["docker.service"];
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

{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.kubectl
    pkgs.kubectx # Kubectl Context switcher
    pkgs.stern # Multi pod and container log tailing for Kubernetes
  ];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".kube"
    ];
  };
}

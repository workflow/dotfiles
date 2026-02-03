{...}: {
  flake.modules.homeManager.kubernetes-tools = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".kube"];
    };

    home.packages = [
      pkgs.kubectl
      pkgs.kubectx # Kubectl Context switcher
      pkgs.stern # Multi pod and container log tailing for Kubernetes
    ];
  };
}

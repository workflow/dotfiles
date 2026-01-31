{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.kubernetes-tools = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [".kube"];
    };

    home.packages = [
      pkgs.kubectl
      pkgs.kubectx
      pkgs.stern
    ];
  };
}

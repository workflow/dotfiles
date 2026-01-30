{pkgs, ...}:
pkgs.writeShellApplication {
  name = "benchmark-containers";
  runtimeInputs = with pkgs; [docker podman coreutils];
  text = builtins.readFile ./benchmark-containers.sh;
}

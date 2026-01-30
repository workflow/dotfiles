{pkgs, ...}:
pkgs.writeShellApplication {
  name = "benchmark-heavy-containers";
  runtimeInputs = with pkgs; [docker podman coreutils];
  text = builtins.readFile ./benchmark-heavy-containers.sh;
}

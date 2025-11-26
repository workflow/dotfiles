{pkgs, ...}:
pkgs.writeShellApplication {
  name = "reset-container-state";
  runtimeInputs = with pkgs; [docker podman coreutils util-linux systemd];
  text = builtins.readFile ./reset-container-state.sh;
}

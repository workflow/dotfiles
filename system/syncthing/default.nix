{pkgs, ...}: {
  # Prevent syncthing from preventing sleep
  powerManagement.powerDownCommands = ''
    export XDG_RUNTIME_DIR=/run/user/1000
    ${pkgs.systemd}/bin/machinectl shell farlion@ /run/current-system/sw/bin/systemctl --user stop syncthing.service
  '';
  powerManagement.resumeCommands = ''
    export XDG_RUNTIME_DIR=/run/user/1000
    ${pkgs.systemd}/bin/machinectl shell farlion@ /run/current-system/sw/bin/systemctl --user start syncthing.service
  '';
}

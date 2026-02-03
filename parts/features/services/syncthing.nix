{...}: {
  flake.modules.nixos.syncthing = {pkgs, ...}: {
    # Prevent syncthing from preventing sleep
    powerManagement.powerDownCommands = ''
      export XDG_RUNTIME_DIR=/run/user/1000
      ${pkgs.systemd}/bin/machinectl shell farlion@ /run/current-system/sw/bin/systemctl --user stop syncthing.service
    '';
    powerManagement.resumeCommands = ''
      export XDG_RUNTIME_DIR=/run/user/1000
      ${pkgs.systemd}/bin/machinectl shell farlion@ /run/current-system/sw/bin/systemctl --user start syncthing.service
    '';
  };

  flake.modules.homeManager.syncthing = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/state/syncthing" # device keys and certificates
        ".config/syncthing" # pre-v1.27.0 uses this instead of $XDG_STATE_HOME above, keeping for backward-compatibility
      ];
      files = [
        ".config/syncthingtray.ini"
      ];
    };

    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
        command = "syncthingtray --wait";
      };
    };

    systemd.user.services.syncthingtray.Service = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

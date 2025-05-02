{...}: let
in {
  boot = {
    loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
    loader.efi.canTouchEfiVariables = true;
    consoleLogLevel = 7;

    initrd = {
      systemd = {
        enable = true;
      };
    };
  };
}

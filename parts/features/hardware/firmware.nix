{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.firmware = {lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = ["/var/lib/fwupd"];
    };

    services.fwupd.enable = true;
  };
}

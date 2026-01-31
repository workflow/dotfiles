{...}: {
  flake.modules.nixos.firmware = {config, lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
      directories = ["/var/lib/fwupd"];
    };

    services.fwupd.enable = true;
  };
}

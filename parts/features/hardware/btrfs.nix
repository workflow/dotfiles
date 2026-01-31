{...}: {
  flake.modules.nixos.btrfs = {config, lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
      directories = ["/var/lib/btrfs"];
    };

    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };
  };
}

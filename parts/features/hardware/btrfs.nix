{...}: {
  flake.modules.nixos.btrfs = {config, lib, ...}:
    lib.mkIf config.dendrix.isBtrfs {
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

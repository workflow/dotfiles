{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.btrfs = {lib, ...}: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = ["/var/lib/btrfs"];
    };

    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };
  };
}

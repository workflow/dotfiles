{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.security = {
    lib,
    pkgs,
    ...
  }: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        "/var/lib/boltd"
        "/run/sudo"
      ];
    };
    home-manager.users.farlion.home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/share/keyrings"
        ".gnupg"
      ];
    };

    services.hardware.bolt.enable = true;

    services.gnome.gnome-keyring.enable = true;
    environment.systemPackages = with pkgs; [
      libsecret
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    programs.seahorse.enable = true;

    security.sudo.extraConfig = ''
      Defaults:root,%wheel timestamp_timeout=30
    '';
    users.users.farlion.extraGroups = ["wheel"];

    services.pcscd.enable = true;
    security.pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          origin = "pam://farlion-realm";
          appid = "pam://farlion-realm";
          cue = false;
        };
      };
      services = {
        login.u2fAuth = false;
        ly.u2fAuth = false;
        sudo.u2fAuth = true;
        swaylock.u2fAuth = true;
      };
    };
    services.udev.packages = [pkgs.yubikey-personalization];
  };
}

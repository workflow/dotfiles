{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".yubico"
    ];
  };

  imports = [
    ./modules/yubikey-touch-detector
  ];

  pam.yubico.authorizedYubiKeys.ids = [
    "cccccchvrtfg"
  ];

  services = {
    yubikey-touch-detector.enable = true;
  };
}

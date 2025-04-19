{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".aws"
    ];
  };

  home.packages = [pkgs.awscli2];
}

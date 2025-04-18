{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.awscli2];

  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".aws"
    ];
  };
}

{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".aws"
    ];
  };

  home.packages = [pkgs.awscli2];
}

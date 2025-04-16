{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.awscli2];

  home.persistence."/persistent/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".aws"
    ];
  };
}

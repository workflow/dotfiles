{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".codex"
    ];
  };

  home.packages = with pkgs.unstable; [codex];
}

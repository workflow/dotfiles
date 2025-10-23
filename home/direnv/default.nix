{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/direnv"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.strict_env = true; # Forces all .envrc scripts through set -euo pipefail
  };
}

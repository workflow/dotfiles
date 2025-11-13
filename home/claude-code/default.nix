{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".claude" # Claude Code global settings, agents, and credentials
    ];
  };

  home.packages = with pkgs; [claude-code];
}

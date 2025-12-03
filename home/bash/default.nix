{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      ".bash_history"
    ];
  };

  programs.bash = {
    enable = true;
    package = pkgs.bashInteractive;
    initExtra = ''
      # Ctrl-x: Copy current command line to clipboard
      copy-command-line() {
        printf '%s' "$READLINE_LINE" | ${pkgs.wl-clipboard}/bin/wl-copy
      }
      bind -x '"\C-x": copy-command-line'
    '';
  };
}

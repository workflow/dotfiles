{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    files = [
      ".bash_history"
    ];
  };
  programs.bash.enable = true;
}

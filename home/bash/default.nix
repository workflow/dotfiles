{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    files = [
      ".bash_history"
    ];
  };
  programs.bash.enable = true;
}

{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    files = [
      ".local/state/lesshst"
    ];
  };

  programs.less = {
    enable = true;
    keys = ''
      k forw-line
      l back-line
    '';
  };
}

{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
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

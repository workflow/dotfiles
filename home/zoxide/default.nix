{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".cache/zoxide" # Some stuff for nushell
      ".local/share/zoxide" # Zoxide DB
    ];
  };

  programs.zoxide = {
    enable = true;
  };
}

{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/obs-studio"
    ];
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vintage-filter
    ];
  };
}

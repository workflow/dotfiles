{
  isImpermanent,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
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
  xdg.desktopEntries = lib.mkIf isFlexbox {
    obs = {
      name = "OBS Studio (NVIDIA GPU)";
      exec = "nvidia-offload obs";
      genericName = "Streaming/Recording Software";
      terminal = false;
      type = "Application";
      categories = ["AudioVideo" "Recorder"];
      icon = "com.obsproject.Studio";
      startupNotify = true;
    };
  };
}

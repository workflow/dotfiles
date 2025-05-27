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
  xdg.desktopEntries = {
    obs = {
      name =
        if isFlexbox
        then "OBS Studio (NVIDIA GPU)"
        else "OBS Studio";
      exec =
        if isFlexbox
        then "nvidia-offload obs"
        else "obs";
      genericName = "Streaming/Recording Software";
      terminal = false;
      type = "Application";
      categories = ["AudioVideo" "Recorder"];
      icon = "com.obsproject.Studio";
      startupNotify = true;
    };
  };
}

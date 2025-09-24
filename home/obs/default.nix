{
  isImpermanent,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";

  # Temporarily sets the default PipeWire source to the virtual mic while OBS runs.
  # Used to workaround double audio capture when using Niri Dynamic Screen Cast Target while OBS virtual-mic is active.
  obsWithVirtualMic = pkgs.writeShellApplication {
    name = "obs-with-virtual-mic";
    runtimeInputs = [
      pkgs.wireplumber # provides wpctl
      pkgs.gnugrep
      pkgs.gnused
      pkgs.coreutils
      pkgs.obs-studio
    ];
    text = builtins.readFile ./scripts/obs-with-virtual-mic.sh;
  };
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/obs-studio"
    ];
  };
  home.packages = [
    obsWithVirtualMic
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vintage-filter
    ];
  };

  xdg.desktopEntries = {
    obs = lib.mkIf isFlexbox {
      name = "OBS Studio (NVIDIA GPU)";
      exec = "nvidia-offload ${obsWithVirtualMic}/bin/obs-with-virtual-mic";
      genericName = "Streaming/Recording Software";
      terminal = false;
      type = "Application";
      categories = ["AudioVideo" "Recorder"];
      icon = "com.obsproject.Studio";
      startupNotify = true;
    };

    "com.obsproject.Studio" = {
      name = "OBS Studio";
      exec = "${obsWithVirtualMic}/bin/obs-with-virtual-mic";
      genericName = "Streaming/Recording Software";
      terminal = false;
      type = "Application";
      categories = ["AudioVideo" "Recorder"];
      icon = "com.obsproject.Studio";
      startupNotify = true;
    };
  };
}

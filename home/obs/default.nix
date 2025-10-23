{
  isImpermanent,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";

  # OBS Control Scripts
  obsMainScene = pkgs.writeShellApplication {
    name = "obs-main-scene";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-main-scene.sh;
  };

  obsScreensharing = pkgs.writeShellApplication {
    name = "obs-screensharing";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-screensharing.sh;
  };

  obsCatcamToggle = pkgs.writeShellApplication {
    name = "obs-catcam-toggle";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-catcam-toggle.sh;
  };

  obsRecordingToggle = pkgs.writeShellApplication {
    name = "obs-recording-toggle";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-recording-toggle.sh;
  };

  obsRecordingPause = pkgs.writeShellApplication {
    name = "obs-recording-pause";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-recording-pause.sh;
  };

  obsWebcamToggle = pkgs.writeShellApplication {
    name = "obs-webcam-toggle";
    runtimeInputs = [pkgs.obs-cmd];
    text = builtins.readFile ./scripts/obs-webcam-toggle.sh;
  };
in {
  home.packages = [
    pkgs.obs-cmd
    obsMainScene
    obsScreensharing
    obsCatcamToggle
    obsRecordingToggle
    obsRecordingPause
    obsWebcamToggle
  ];

  home.persistence."/persist" = lib.mkIf isImpermanent {
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

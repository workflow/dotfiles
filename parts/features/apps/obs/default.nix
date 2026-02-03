{...}: {
  flake.modules.homeManager.obs = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    isFlexbox = osConfig.dendrix.hostname == "flexbox";

    # OBS Control Scripts
    obsMainScene = pkgs.writeShellApplication {
      name = "obs-main-scene";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-main-scene.sh;
    };

    obsScreensharing = pkgs.writeShellApplication {
      name = "obs-screensharing";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-screensharing.sh;
    };

    obsCatcamToggle = pkgs.writeShellApplication {
      name = "obs-catcam-toggle";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-catcam-toggle.sh;
    };

    obsRecordingToggle = pkgs.writeShellApplication {
      name = "obs-recording-toggle";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-recording-toggle.sh;
    };

    obsRecordingPause = pkgs.writeShellApplication {
      name = "obs-recording-pause";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-recording-pause.sh;
    };

    obsWebcamToggle = pkgs.writeShellApplication {
      name = "obs-webcam-toggle";
      runtimeInputs = [pkgs.obs-cmd];
      text = builtins.readFile ./_scripts/obs-webcam-toggle.sh;
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

    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/obs-studio"];
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        pkgs.unstable.obs-studio-plugins.obs-noise
        pkgs.unstable.obs-studio-plugins.pixel-art
        pkgs.unstable.obs-studio-plugins.obs-recursion-effect
        pkgs.unstable.obs-studio-plugins.obs-retro-effects
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
  };
}

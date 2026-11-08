{...}: {
  flake.modules.homeManager.signal = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    # Chromium's direct V4L2 path skips devices that also advertise output caps,
    # which hides the exclusive_caps=0 OBS Cam (see video.nix); PipeWire lists it.
    # Wrapped rather than .override'd: commandLineArgs would rebuild Signal from source.
    signal = pkgs.symlinkJoin {
      name = "signal-desktop-pipewire-camera";
      paths = [pkgs.signal-desktop];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/signal-desktop --add-flags "--enable-features=WebRtcPipeWireCamera"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/Signal"
      ];
    };

    home.packages = [signal];
  };
}

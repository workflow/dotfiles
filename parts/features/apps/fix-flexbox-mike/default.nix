{config, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.fix-flexbox-mike = {
    lib,
    pkgs,
    ...
  }: let
    isFlexbox = cfg.dendrix.hostname == "flexbox";
    xps-9700-mic-fixer = pkgs.writeShellApplication {
      name = "xps-9700-mic-fixer";
      runtimeInputs = [pkgs.alsa-utils];
      text = builtins.readFile ./_scripts/xps-9700-mic-fixer.sh;
    };
  in {
    systemd.user.services.fixXPS9700Mike = lib.mkIf isFlexbox {
      Unit = {
        Description = "Fix ALSA settings for internal mic on Dell XPS 9700";
      };
      Install.WantedBy = ["pipewire.service"];
      Service = {
        Environment = "PATH=$PATH:/run/current-system/sw/bin";
        ExecStart = "${xps-9700-mic-fixer}/bin/xps-9700-mic-fixer";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}

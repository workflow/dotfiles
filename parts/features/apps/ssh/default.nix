{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.ssh = {
    lib,
    pkgs,
    ...
  }: let
    ssh-add-all = pkgs.writeShellApplication {
      name = "ssh-add-all";
      runtimeInputs = with pkgs; [openssh coreutils];
      text = builtins.readFile ./_scripts/ssh-add-all.sh;
    };
  in {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".ssh"
      ];
    };

    home.packages = [ssh-add-all];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };

    services.ssh-agent.enable = false;

    home.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    };
  };
}

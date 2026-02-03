{...}: {
  flake.modules.homeManager.ssh = {
    osConfig,
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
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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

    # Disable default ssh-agent since we use gcr-ssh-agent (via services.gnome.gnome-keyring)
    services.ssh-agent.enable = false;

    home.sessionVariables = {
      # Point to the new gcr SSH agent socket (NixOS 25.11+)
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    };
  };
}

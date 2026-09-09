{...}: {
  flake.modules.homeManager.herdr = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
    jjWorkspaceAction = key: action: description: {
      inherit key description;
      type = "plugin_action";
      command = "nathanflurry.jj-workspace.${action}";
    };
    settings = {
      # Self-updating is pointless under Nix; skip the background version check.
      update.version_check = false;
      keys.command = [
        (jjWorkspaceAction "prefix+a" "new-tab" "new jj workspace tab")
        (jjWorkspaceAction "prefix+shift+a" "new" "new jj workspace")
        (jjWorkspaceAction "prefix+d" "remove" "remove jj workspace")
      ];
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      # .config/herdr also holds the imperatively installed (and locally
      # patched) plugins; .herdr holds the jj workspace checkouts.
      directories = [".config/herdr" ".herdr"];
    };

    home.packages = [pkgs.unstable.herdr];

    xdg.configFile."herdr/config.toml".source =
      tomlFormat.generate "herdr-config.toml" settings;

    # Pane shells inherit the server's environment. Without a service, the
    # first `herdr` invocation spawns the server from whatever shell it runs
    # in, leaking that project's devenv/direnv vars into every pane.
    systemd.user.services.herdr-server = {
      Unit.Description = "herdr agent multiplexer server";
      Service = {
        ExecStart = "${pkgs.unstable.herdr}/bin/herdr server";
        Restart = "on-failure";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}

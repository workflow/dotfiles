{...}: {
  flake.modules.homeManager.herdr = {
    osConfig,
    lib,
    pkgs,
    config,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
    claudeHookPath = "${config.home.homeDirectory}/.claude/hooks/herdr-agent-state.sh";
    claudeAgentStateHook = pkgs.writeShellApplication {
      name = "herdr-agent-state";
      runtimeInputs = [pkgs.python3];
      text = builtins.readFile ./scripts/herdr-agent-state.sh;
    };
    claudeTabTitleHook = pkgs.writeShellApplication {
      name = "herdr-tab-title";
      runtimeInputs = [pkgs.unstable.herdr pkgs.jq];
      text = builtins.readFile ./scripts/herdr-tab-title.sh;
    };
    jjWorkspaceAction = key: action: description: {
      inherit key description;
      type = "plugin_action";
      command = "nathanflurry.jj-workspace.${action}";
    };
    settings = {
      # Herdr can't write its "onboarding done" marker into the read-only
      # store-managed config, so declare it done.
      onboarding = false;
      # Self-updating is pointless under Nix; skip the background version check.
      update.version_check = false;
      # peon-ping owns audio notifications; herdr's agent-state sounds double up.
      ui.sound.enabled = false;
      keys = {
        prefix = "ctrl+space";
        # Direct chords for frequent motions; directions follow the jkl;
        # home-row remap (j=left k=down l=up ;=right).
        focus_pane_left = "alt+j";
        focus_pane_down = "alt+k";
        focus_pane_up = "alt+l";
        focus_pane_right = "alt+semicolon";
        next_workspace = "alt+n";
        previous_workspace = "alt+p";
        next_agent = "alt+a";
        previous_agent = "alt+shift+a";
        switch_tab = "alt+1..9";
        command = [
          (jjWorkspaceAction "prefix+a" "new-tab" "new jj workspace tab")
          (jjWorkspaceAction "prefix+shift+a" "new" "new jj workspace")
          (jjWorkspaceAction "prefix+d" "remove" "remove jj workspace")
        ];
      };
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

    # herdr's claude integration: a SessionStart hook reports the session →
    # pane mapping over the herdr socket, so agents are recognized even when
    # devenv nests them away from the pane's foreground process group.
    # Installed at herdr's canonical path so `herdr integration status` sees it.
    home.file.${claudeHookPath}.source = lib.getExe claudeAgentStateHook;

    programs.claude-code.settings.hooks = {
      SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "'${claudeHookPath}' session";
              timeout = 10;
            }
            {
              type = "command";
              command = lib.getExe claudeTabTitleHook;
              async = true;
              timeout = 10;
            }
          ];
        }
      ];
      # Re-sync at each turn end so the label follows session renames.
      Stop = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = lib.getExe claudeTabTitleHook;
              async = true;
              timeout = 10;
            }
          ];
        }
      ];
    };

    # Pane shells inherit the server's environment. Without a service, the
    # first `herdr` invocation spawns the server from whatever shell it runs
    # in, leaking that project's devenv/direnv vars into every pane.
    systemd.user.services.herdr-server = {
      Unit.Description = "herdr agent multiplexer server";
      # A changed unit is restarted during `nh os switch`, killing every pane
      # and the agents in them. Keep the old server running; restart manually
      # (systemctl --user restart herdr-server) when no sessions are at risk.
      Unit.X-SwitchMethod = "keep-old";
      Service = {
        ExecStart = "${pkgs.unstable.herdr}/bin/herdr server";
        # Native detection reads the pty's foreground process group, which the
        # devenv hook's nested shell session hides agents from; child-groups
        # walks pane child processes instead. Revisit on herdr >= 0.9, where
        # the claude integration may make this fallback unnecessary.
        Environment = ["HERDR_PROCESS_DETECTION=child-groups"];
        Restart = "on-failure";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}

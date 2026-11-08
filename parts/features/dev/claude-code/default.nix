{...}: {
  flake.modules.homeManager.claude-code = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    model = "claude-opus-5-5";
    configDir = config.programs.claude-code.configDir;
    stateFile = "${configDir}/.claude.json";
    statusline = pkgs.writeShellApplication {
      name = "claude-statusline";
      runtimeInputs = [pkgs.jq config.programs.jujutsu.package];
      text = builtins.readFile ./scripts/claude-statusline.sh;
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        # Claude Code global settings, agents, credentials — and .claude.json,
        # relocated here from ~/.claude.json by the CLAUDE_CONFIG_DIR wrapper below.
        ".claude"
        ".cache/claude-cli-nodejs" # Claude Code cache
      ];
    };

    programs.claude-code = {
      enable = true;
      # The codex plugin's hooks invoke bare `node`, so keep it on claude's PATH
      # without exposing it system-wide.
      #
      # CLAUDE_CONFIG_DIR relocates .claude.json from ~/.claude.json into
      # ~/.claude. Impermanence bind-mounts single persisted files, and
      # rename(2) over a mount point fails with EBUSY, so Claude Code's
      # write-temp-then-rename save falls back to rewriting in place without
      # truncation — leaving a stale tail (corrupt JSON) whenever the new
      # state is shorter than the old. Inside the bind-mounted ~/.claude
      # *directory* renames work, so the atomic save path succeeds again.
      package = pkgs.symlinkJoin {
        name = "claude-code-wrapped";
        paths = [pkgs.unstable.claude-code];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --prefix PATH : ${pkgs.nodejs}/bin \
            --set-default CLAUDE_CONFIG_DIR ${configDir}
        '';
      };

      context = ../AGENTS.md;

      skills.pr-review = ./skills/pr-review;

      settings = {
        permissions = {
          defaultMode = "auto";
          allow =
            map (prefix: "Bash(${prefix}:*)") config.dendrix.agents.shellAllowlist
            ++ [
              "Grep"
              "WebFetch(domain:github.com)"
              "WebSearch"
            ];
          ask =
            map (pattern: "Bash(${pattern})") config.dendrix.agents.shellAsklist
            # Keep manual approval for file edits even in auto mode (ask beats
            # the auto-mode classifier).
            ++ [
              "Edit"
              "Write"
              "NotebookEdit"
            ];
          deny =
            map (pattern: "Bash(${pattern})") config.dendrix.agents.shellDenylist
            ++ [
              "Read(./.env)"
              "Read(./.env.*)"
              "Read(./secrets/secrets.json)"
              "Read(./config/credentials.json)"
            ];
        };
        # Prose rules for the auto-mode permission classifier; "$defaults"
        # keeps the built-in rules.
        autoMode.soft_deny = ["$defaults"] ++ config.dendrix.agents.autoModeSoftDeny;
        # The Bash tool has no TTY, so sudo fails its terminal check before PAM
        # (pam_u2f yubikey touch) runs. With an askpass helper configured, sudo
        # skips that check; the dummy helper is never consulted because pam_u2f
        # needs no input, and it forecloses password fallback entirely.
        env = {
          SUDO_ASKPASS = lib.getExe' pkgs.coreutils "false";
          # Spelled out instead of CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC:
          # since 2.1.318 that also disables AI session titles and the terminal
          # title, which the status line and herdr tab names are built from.
          # The nixpkgs wrapper already sets DISABLE_AUTOUPDATER.
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
          DISABLE_BUG_COMMAND = "1";
        };
        # Don't auto-connect Remote Control; /rc stays available per session.
        remoteControlAtStartup = false;
        statusLine = {
          type = "command";
          command = lib.getExe statusline;
        };
        alwaysThinkingEnabled = true;
        # Top-level effortLevel only reaches models on Claude Code's legacy
        # allowlist; newer models (e.g. Opus 5.5) read it per model.
        effortLevel = "high";
        modelSettings.${model}.effortLevel = "high";
        inherit model;
        extraKnownMarketplaces = {
          openai-codex = {
            source = {
              source = "github";
              repo = "openai/codex-plugin-cc";
            };
          };
        };
        enabledPlugins = {
          "codex@openai-codex" = true;
        };
      };
    };

    # The home-manager module symlinks ~/.claude/settings.json into the read-only
    # Nix store, so Claude Code's runtime updates (e.g. /effort) fail with EROFS.
    # Skip the symlink and install the module-generated JSON as a writable copy.
    # Each `nh os switch` resets it to the Nix-defined value, which is acceptable
    # because the runtime mutations Claude Code performs here are session-scoped.
    #
    # The upstream module keys the entry by absolute path (`${cfg.configDir}/...`,
    # defaulting to `/home/$USER/.claude/...`), not relative, so this override has
    # to match exactly or it won't take effect.
    home.file."${config.programs.claude-code.configDir}/settings.json".enable = lib.mkForce false;

    home.activation.claudeCodeWritableSettings = let
      settingsSource = config.home.file."${config.programs.claude-code.configDir}/settings.json".source;
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        dest="${config.programs.claude-code.configDir}/settings.json"
        run rm -f "$dest"
        run install -m644 -DT ${settingsSource} "$dest"
      '';

    # One-time migration of the pre-CLAUDE_CONFIG_DIR state file. ~/.claude.json
    # may still be bind-mounted until the next reboot (mv would hit EBUSY), so
    # copy it, then drop the now-unpersisted copy in /persist. A copied file
    # carrying the stale-tail corruption is fine: Claude Code quarantines it
    # and restores from its own ~/.claude/backups.
    home.activation.claudeCodeMigrateStateFile =
      lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        old="${config.home.homeDirectory}/.claude.json"
        if [ -e "$old" ] && [ ! -e "${stateFile}" ]; then
          run cp "$old" "${stateFile}"
        fi
        ${lib.optionalString osConfig.dendrix.isImpermanent ''
          run rm -f "/persist${config.home.homeDirectory}/.claude.json"
        ''}
      '';

    # See https://dylancastillo.co/til/fix-claude-code-shift-enter-alacritty.html
    programs.alacritty.settings.keyboard.bindings = [
      {
        key = "Return";
        mods = "Shift";
        chars = "\n";
      }
    ];
  };
}

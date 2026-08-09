{inputs, ...}: {
  flake.modules.homeManager.peon-ping = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: let
    # Claude Code and opencode fire hooks outside a login shell, so bake the
    # Linux audio/notification tools into the upstream package's PATH.
    peon-ping = pkgs.symlinkJoin {
      name = "peon-ping-wrapped";
      paths = [inputs.peon-ping.packages.${pkgs.stdenv.hostPlatform.system}.default];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/peon \
          --prefix PATH : ${lib.makeBinPath (with pkgs; [pipewire libnotify procps])}
      '';
    };

    peon-ping-waybar = pkgs.writeShellApplication {
      name = "peon-ping-waybar";
      runtimeInputs = [peon-ping pkgs.gnugrep];
      text = builtins.readFile ./scripts/peon-ping-waybar.sh;
    };

    peon-ping-toggle = pkgs.writeShellApplication {
      name = "peon-ping-toggle";
      runtimeInputs = [peon-ping pkgs.gnugrep];
      text = builtins.readFile ./scripts/peon-ping-toggle.sh;
    };

    focus-claude-session = pkgs.writeShellApplication {
      name = "focus-claude-session";
      runtimeInputs = with pkgs; [niri jq psmisc gnugrep];
      text = builtins.readFile ./scripts/focus-claude-session.sh;
    };

    configSeed = (pkgs.formats.json {}).generate "peon-ping-config-seed" config.programs.peon-ping.settings;

    # OpenCode fires several busy status events per prompt, which the upstream
    # adapter each maps to UserPromptSubmit — tripping peon.sh's spam detection
    # on normal use. Dedupe to actual idle->busy transitions.
    opencodeAdapter = pkgs.runCommand "peon-ping-opencode-adapter.ts" {} ''
      cp ${peon-ping}/share/peon-ping/adapters/opencode/peon-ping.ts .
      chmod +w peon-ping.ts
      patch peon-ping.ts ${./patches/opencode-busy-dedupe.patch}
      cp peon-ping.ts $out
    '';

    peonHook = {
      type = "command";
      command = "${peon-ping}/bin/peon";
      timeout = 10;
      async = true;
    };
    mkPeonEvent = event: {
      ${event} = [
        {
          matcher = "";
          hooks = [peonHook];
        }
      ];
    };
  in {
    imports = [inputs.peon-ping.homeManagerModules.default];

    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".openpeon"];
    };

    programs.peon-ping = {
      enable = true;
      package = peon-ping;
      enableBashIntegration = false;
      enableZshIntegration = false;
      installPacks = [
        "acolyte_de"
        "aoe2"
        "murloc"
        "peon"
        "peon_de"
        {
          name = "worms_armageddon_pt";
          src = pkgs.fetchFromGitHub {
            owner = "vmrfreitas";
            repo = "openpeon-worms-pt";
            rev = "a82c32f002d72f263e656addae85e89060f2f087";
            sha256 = "sha256-Tidlp4fVJoV1UpdLGn8gXNN+icdWHHmPlNJz9LfT8J8=";
          };
        }
      ];
      settings = {
        default_pack = "peon_de";
        ide_rules = [
          {
            ide = "opencode";
            pack = "worms_armageddon_pt";
          }
        ];
        volume = 0.5;
        enabled = true;
        desktop_notifications = true;
        categories = {
          "session.start" = true;
          "task.acknowledge" = false;
          "task.complete" = true;
          "task.error" = true;
          "input.required" = true;
          "resource.limit" = true;
          "user.spam" = true;
        };
        annoyed_threshold = 3;
        annoyed_window_seconds = 10;
        session_start_cooldown_seconds = 30;
      };
    };

    home.packages = [peon-ping peon-ping-waybar peon-ping-toggle focus-claude-session];

    # `peon use/toggle/notifications` write config.json at runtime, so it must
    # stay a seeded mutable file instead of the module's read-only store symlink.
    home.file.".openpeon/config.json".enable = false;
    home.activation.seedPeonConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f "$HOME/.openpeon/config.json" ]; then
        install -m 644 ${configSeed} "$HOME/.openpeon/config.json"
      fi
    '';

    # The opencode adapter routes all events through peon.sh, but only probes
    # ~/.claude/hooks/peon-ping/peon.sh — give it something to find there.
    home.file.".claude/hooks/peon-ping/peon.sh".source = "${peon-ping}/bin/peon";
    xdg.configFile."opencode/plugins/peon-ping.ts".source = opencodeAdapter;

    # Declarative equivalent of the upstream module's claudeCodeIntegration,
    # which mutates ~/.claude/settings.json imperatively and would clash with
    # the home-manager-managed settings file.
    programs.claude-code = {
      skills = lib.genAttrs [
        "peon-ping-config"
        "peon-ping-log"
        "peon-ping-rename"
        "peon-ping-toggle"
        "peon-ping-use"
      ] (name: "${peon-ping}/share/peon-ping/skills/${name}");

      settings.hooks = lib.mkMerge ([
          {
            SessionStart = [
              {
                matcher = "";
                hooks = [(builtins.removeAttrs peonHook ["async"])];
              }
            ];
            UserPromptSubmit = [
              {
                matcher = "";
                hooks = [peonHook];
              }
              {
                matcher = "";
                hooks = [
                  {
                    type = "command";
                    command = "${peon-ping}/share/peon-ping/scripts/hook-handle-use.sh";
                    timeout = 5;
                  }
                  {
                    type = "command";
                    command = "${peon-ping}/share/peon-ping/scripts/hook-handle-rename.sh";
                    timeout = 5;
                  }
                ];
              }
            ];
            PostToolUseFailure = [
              {
                matcher = "Bash";
                hooks = [peonHook];
              }
            ];
          }
        ]
        ++ map mkPeonEvent [
          "SessionEnd"
          "SubagentStart"
          "Stop"
          "Notification"
          "PermissionRequest"
          "PreCompact"
        ]);
    };
  };
}

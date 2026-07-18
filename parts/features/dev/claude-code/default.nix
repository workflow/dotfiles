{...}: {
  flake.modules.homeManager.claude-code = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".claude" # Claude Code global settings, agents, and credentials
        ".cache/claude-cli-nodejs" # Claude Code cache
      ];
      files = [
        ".claude.json" # Claude Code runtime state (credentials, project settings, etc.)
      ];
    };

    programs.claude-code = {
      enable = true;
      # The codex plugin's hooks invoke bare `node`, so keep it on claude's PATH
      # without exposing it system-wide.
      package = pkgs.symlinkJoin {
        name = "claude-code-wrapped";
        paths = [pkgs.unstable.claude-code];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --prefix PATH : ${pkgs.nodejs}/bin
        '';
      };

      context = ./CLAUDE.md;

      skills.pr-review = ./skills/pr-review;

      settings = {
        permissions = {
          allow = [
            "Bash(gh pr view:*)"
            "Bash(gh pr diff:*)"
            "Bash(gh api:*)"
            "Bash(gh issue view:*)"
            "Bash(gh pr checks:*)"
            "Bash(gh release list:*)"
            "Bash(gh release view:*)"
            "Bash(gh run list:*)"
            "Bash(gh run view:*)"
            "Bash(jj log:*)"
            "Bash(jj diff:*)"
            "Bash(jj git fetch:*)"
            "Bash(jj status)"
            "Bash(jj st:*)"
            "Bash(jj show:*)"
            "Grep"
            "WebFetch(domain:github.com)"
            "WebSearch"
          ];
          deny = [
            "Read(./.env)"
            "Read(./.env.*)"
            "Read(./secrets/secrets.json)"
            "Read(./config/credentials.json)"
            # Block destructive gh api flags (deny overrides allow)
            "Bash(gh api *--method*)"
            "Bash(gh api * -X *)"
            "Bash(gh api * -f *)"
            "Bash(gh api *--field*)"
            "Bash(gh api * -F *)"
            "Bash(gh api *--raw-field*)"
            "Bash(gh api *--input*)"
          ];
        };
        alwaysThinkingEnabled = true;
        effortLevel = "high";
        model = "claude-fable-5";
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

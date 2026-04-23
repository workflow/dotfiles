{...}: {
  flake.modules.homeManager.claude-code = {
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
      package = pkgs.symlinkJoin {
        name = "claude-code-wrapped";
        paths = [pkgs.unstable.claude-code];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --prefix PATH : ${pkgs.nodejs}/bin
        '';
      };

      memory.source = ./CLAUDE.md;

      skills.pr-review = ./skills/pr-review;

      settings = {
        permissions = {
          allow = [
            "Bash(gh pr view:*)"
            "Bash(gh pr diff:*)"
            "Bash(gh api:*)"
            "Bash(gh issue view:*)"
            "Bash(jj log:*)"
            "Bash(jj diff:*)"
            "Bash(jj status)"
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

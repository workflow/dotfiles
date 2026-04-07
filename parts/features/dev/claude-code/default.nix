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
        paths = [ pkgs.unstable.claude-code ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --prefix PATH : ${pkgs.nodejs}/bin
        '';
      };

      memory.source = ./CLAUDE.md;

      settings = {
        permissions = {
          allow = [
            "Bash(jj log:*)"
            "Bash(jj diff:*)"
            "Bash(jj status)"
            "Grep"
            "WebFetch(domain:github.com)"
            "WebSearch"
          ];
          deny = [
            "Read(./.env)"
            "Read(./.env.*)"
            "Read(./secrets/secrets.json)"
            "Read(./config/credentials.json)"
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
          "rust-analyzer-lsp@claude-plugins-official" = true;
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

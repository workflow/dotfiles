{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
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
    package = pkgs.unstable.claude-code;

    memory.source = ./CLAUDE.md;

    settings = {
      permissions = {
        deny = [
          "Read(./.env)"
          "Read(./.env.*)"
          "Read(./secrets/secrets.json)"
          "Read(./config/credentials.json)"
        ];
      };
      alwaysThinkingEnabled = true;
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
}

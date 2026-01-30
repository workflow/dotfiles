{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.claude-code = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".claude"
        ".cache/claude-cli-nodejs"
      ];
      files = [
        ".claude.json"
      ];
    };

    programs.claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;

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
      };
    };

    programs.alacritty.settings.keyboard.bindings = [
      {
        key = "Return";
        mods = "Shift";
        chars = "\n";
      }
    ];
  };
}

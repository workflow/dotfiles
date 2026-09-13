# Codex config is split across two layers. /etc/codex/config.toml is Codex's
# system layer (lowest precedence) and carries everything Nix manages; hooks
# declared there count as managed, so Codex trusts them by policy instead of
# demanding a /hooks review after every change. ~/.codex/config.toml stays a
# plain file Codex itself writes to (project trust, model migrations,
# allow-list amendments), which a store symlink would break.
{...}: {
  flake.modules.nixos.codex = {
    config,
    pkgs,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
    settings = config.home-manager.users.farlion.dendrix.codex.settings;
  in {
    environment.etc."codex/config.toml".source = tomlFormat.generate "codex-system-config" settings;
  };

  flake.modules.homeManager.codex = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.dendrix.codex;
    agents = config.dendrix.agents;

    agentRules = lib.concatLines (lib.unique (
      rulesFor "allow" (lib.filter (prefix: !(isShadowed prefix)) agents.shellAllowlist)
      ++ rulesFor "prompt" agents.shellAsklist
      ++ rulesFor "forbidden" agents.shellDenylist
    ));

    rulesFor = decision: patterns:
      map (pattern: prefixRule decision (prefixWords pattern)) (lib.filter isPrefixPattern patterns);
    prefixRule = decision: words: ''prefix_rule(pattern = ${builtins.toJSON words}, decision = "${decision}")'';

    # An ask pattern Codex can't express (e.g. "gh api *--method*") would let
    # its allow prefix run unsandboxed without a prompt; drop such allows so
    # Codex falls back to asking.
    isShadowed = prefix: lib.any (pattern: lib.hasPrefix "${prefix} " (lib.removePrefix "*" pattern)) inexpressible;
    inexpressible = lib.filter (pattern: !(isPrefixPattern pattern)) (agents.shellAsklist ++ agents.shellDenylist);

    # Codex rules match exact argv prefixes, so only patterns whose wildcards
    # sit at the edges translate. A leading "*" is droppable because Codex
    # splits compound shell commands before matching.
    isPrefixPattern = pattern:
      !(lib.hasInfix "*" (stripStars pattern))
      && prefixWords pattern != []
      && isCommandName (lib.head (prefixWords pattern));
    isCommandName = word: builtins.match "[A-Za-z0-9._-]+" word != null;
    prefixWords = pattern: lib.filter (word: word != "") (lib.splitString " " (stripStars pattern));
    stripStars = pattern: lib.removeSuffix "*" (lib.removePrefix "*" pattern);

    skillLinks = lib.mapAttrs' (name: dir: lib.nameValuePair ".codex/skills/${name}" {source = dir;}) cfg.skills;
  in {
    # Not via programs.codex: with home.preferXdgDirectories it would move
    # CODEX_HOME to ~/.config/codex, away from the persisted ~/.codex state.
    options.dendrix.codex = {
      settings = lib.mkOption {
        type = (pkgs.formats.toml {}).type;
        default = {};
        description = "Codex config.toml contents, installed as the system layer /etc/codex/config.toml";
      };
      skills = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = {};
        description = "Skill directories linked into ~/.codex/skills/<name>";
      };
    };

    config = {
      home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
        directories = [".codex"];
      };

      home.packages = [pkgs.unstable.codex];

      home.file =
        {
          ".codex/AGENTS.md".source = ./AGENTS.md;
          ".codex/rules/agents.rules".text = agentRules;
        }
        // skillLinks;

      dendrix.codex = {
        skills.pr-review = ./claude-code/skills/pr-review;
        settings = {
          model = "gpt-6-astra";
          model_reasoning_effort = "high";
          personality = "pragmatic";
          # Same reasoning as claude-code: agent shells have no TTY, so sudo
          # needs an askpass helper to reach pam_u2f; the dummy is never consulted.
          shell_environment_policy.set.SUDO_ASKPASS = lib.getExe' pkgs.coreutils "false";
        };
      };
    };
  };
}

# Plannotator: browser UI for reviewing agent plans, diffs and markdown.
# https://github.com/backnotprop/plannotator
#
# Upstream ships an install script that writes the binary, hooks, skills and
# per-agent config into $HOME. Instead the binary comes from numtide's
# llm-agents.nix, and the Claude Code plugin (loaded via --plugin-dir, no
# runtime marketplace clone), the skills/commands and the opencode plugin
# version all come from that package's `src`/`version`, so the hook protocol
# and binary can't drift apart.
{inputs, ...}: {
  # Serves llm-agents.nix builds against its own nixpkgs pin.
  flake.modules.nixos.plannotator = {
    nix.settings = {
      substituters = ["https://cache.numtide.com"];
      trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
    };
  };

  flake.modules.homeManager.plannotator = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    upstream = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.plannotator;
    inherit (upstream) version src;

    # Hooks fire from the agent's environment, not a login shell; make sure
    # the tools plannotator shells out to are reachable without shadowing
    # whatever the user already has on PATH.
    plannotator = pkgs.symlinkJoin {
      name = "plannotator-wrapped-${version}";
      paths = [upstream];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/plannotator \
          --suffix PATH : ${lib.makeBinPath (with pkgs; [git jujutsu xdg-utils procps])}
      '';
      meta.mainProgram = "plannotator";
    };

    skillNames = ["plannotator-review" "plannotator-annotate" "plannotator-last"];
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".plannotator" # saved plans, feedback history, config.json, sessions
        ".cache/opencode" # opencode installs npm plugins (incl. @plannotator/opencode) here
      ];
    };

    home.packages = [plannotator];

    programs.claude-code = {
      plugins = ["${src}/apps/hook"];
      skills = lib.genAttrs skillNames (name: "${src}/apps/skills/claude/${name}");
    };

    programs.opencode = {
      settings.plugin = ["@plannotator/opencode@${version}"];
      commands = lib.genAttrs skillNames (name: builtins.readFile "${src}/apps/opencode-plugin/commands/${name}.md");
    };

    dendrix.codex = {
      skills = lib.genAttrs skillNames (name: "${src}/apps/skills/core/${name}");
      # Codex has no ExitPlanMode to intercept; upstream reviews plans from the
      # Stop hook instead, with the same timeout as the Claude plugin's hook.
      settings.hooks.Stop = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = lib.getExe plannotator;
              timeout = 345600;
            }
          ];
        }
      ];
    };
  };
}

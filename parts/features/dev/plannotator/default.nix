# Plannotator: browser UI for reviewing agent plans, diffs and markdown.
# https://github.com/backnotprop/plannotator
#
# Upstream ships an install script that writes the binary, hooks, skills and
# per-agent config into $HOME. Everything here is pinned to one release tag
# instead: the prebuilt binary, the Claude Code plugin (loaded via
# --plugin-dir, no runtime marketplace clone) and the skills/commands all come
# from the same `version`, so the hook protocol and binary can't drift apart.
{...}: {
  flake.modules.homeManager.plannotator = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    version = "0.27.24";

    src = pkgs.fetchFromGitHub {
      owner = "backnotprop";
      repo = "plannotator";
      tag = "v${version}";
      hash = "sha256-bMZhTKrp02jD3WPDuet3mj7sN542Pai4yTjPG+61VjA=";
    };

    releaseBinaries = {
      x86_64-linux = {
        asset = "plannotator-linux-x64";
        hash = "sha256-qUn+xizTOORvAwYj1Y7eGkqrPg+de+T6i/CQrFQ7q58=";
      };
      aarch64-linux = {
        asset = "plannotator-linux-arm64";
        hash = "sha256-v8+kmmXT/oB9LIRonj2nKUxMZNaoFms20wcuWL5iaSs=";
      };
    };

    system = pkgs.stdenv.hostPlatform.system;
    release =
      releaseBinaries.${system}
      or (throw "plannotator: no release binary for ${system}");

    # Bun-compiled single binary; only links glibc, so autoPatchelf suffices.
    plannotator = pkgs.stdenv.mkDerivation {
      pname = "plannotator";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://github.com/backnotprop/plannotator/releases/download/v${version}/${release.asset}";
        inherit (release) hash;
      };

      dontUnpack = true;
      dontStrip = true;
      nativeBuildInputs = [pkgs.autoPatchelfHook pkgs.makeWrapper];
      buildInputs = [pkgs.stdenv.cc.cc.lib];

      # Hooks fire from the agent's environment, not a login shell; make sure
      # the tools plannotator shells out to are reachable without shadowing
      # whatever the user already has on PATH.
      installPhase = ''
        runHook preInstall
        install -Dm755 $src $out/bin/plannotator
        wrapProgram $out/bin/plannotator \
          --suffix PATH : ${lib.makeBinPath (with pkgs; [git jujutsu xdg-utils procps])}
        runHook postInstall
      '';

      meta = {
        description = "Annotate and review coding agent plans and code diffs visually";
        homepage = "https://plannotator.ai";
        license = with lib.licenses; [mit asl20];
        mainProgram = "plannotator";
        platforms = builtins.attrNames releaseBinaries;
      };
    };

    # Claude Code fills ExitPlanMode's `plan` from the plan file when the
    # assistant message is recorded. When the model batches its plan Write/Edit
    # into that same message, the snapshot predates the edit and plannotator
    # shows the previous plan. Re-read `planFilePath` when the hook runs.
    # Drop once upstream reads the plan file itself:
    # https://github.com/backnotprop/plannotator/pull/1667
    mkFreshPlanHook = plannotatorPkg:
      pkgs.writeShellApplication {
        name = "plannotator-fresh-plan";
        runtimeInputs = [plannotatorPkg pkgs.jq];
        text = builtins.readFile ./scripts/plannotator-fresh-plan.sh;
      };
    freshPlanHook = mkFreshPlanHook plannotator;
    freshPlanHookTests = let
      echoPlannotator = pkgs.writeShellApplication {
        name = "plannotator";
        text = "cat";
      };
    in
      pkgs.runCommand "plannotator-fresh-plan-tests" {
        nativeBuildInputs = [(mkFreshPlanHook echoPlannotator) pkgs.jq];
      } ''
        bash ${./scripts/plannotator-fresh-plan.test.sh}
        touch $out
      '';

    claudePlugin =
      pkgs.runCommand "plannotator-claude-plugin" {
        nativeBuildInputs = [pkgs.jq];
        inherit freshPlanHookTests;
      } ''
        cp -r ${src}/apps/hook $out
        chmod -R u+w $out
        hooks=$out/hooks/hooks.json
        exitPlanCommand='.hooks.PermissionRequest[] | select(.matcher == "ExitPlanMode") | .hooks[].command'
        jq -e "[$exitPlanCommand] == [\"plannotator\"]" $hooks >/dev/null \
          || { echo "upstream ExitPlanMode hook changed, revisit plannotator-fresh-plan" >&2; exit 1; }
        jq --arg cmd ${lib.getExe freshPlanHook} "($exitPlanCommand) = \$cmd" $hooks > hooks.json
        mv hooks.json $hooks
      '';

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
      plugins = [claudePlugin];
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

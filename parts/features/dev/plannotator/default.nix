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
    version = "0.27.12";

    src = pkgs.fetchFromGitHub {
      owner = "backnotprop";
      repo = "plannotator";
      tag = "v${version}";
      hash = "sha256-Z3k/YnGXB/OGL3BP+2Z/Ck1H28rJeA+ihdZ8EaXKwIA=";
    };

    releaseBinaries = {
      x86_64-linux = {
        asset = "plannotator-linux-x64";
        hash = "sha256-R5uicXyqLad+Lhiwo9YfQldHzl+mh7JBN4Qr1VV09m0=";
      };
      aarch64-linux = {
        asset = "plannotator-linux-arm64";
        hash = "sha256-5gP6u+lFk4v06fwvAuwEEs9wZlhZ/+PKAUwiHIKqEBk=";
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

    claudeSkills = ["plannotator-review" "plannotator-annotate" "plannotator-last"];
    opencodeCommands = ["plannotator-review" "plannotator-annotate" "plannotator-last"];
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
      skills = lib.genAttrs claudeSkills (name: "${src}/apps/skills/claude/${name}");
    };

    programs.opencode = {
      settings.plugin = ["@plannotator/opencode@${version}"];
      commands = lib.genAttrs opencodeCommands (name: builtins.readFile "${src}/apps/opencode-plugin/commands/${name}.md");
    };
  };
}

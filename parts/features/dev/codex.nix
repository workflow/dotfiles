{...}: {
  flake.modules.homeManager.codex = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".codex"];
    };

    home.packages = [pkgs.unstable.codex];

    # Not via programs.codex: with home.preferXdgDirectories it would move
    # CODEX_HOME to ~/.config/codex, away from the persisted ~/.codex state.
    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
  };
}

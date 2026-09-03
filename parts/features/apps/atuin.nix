{...}: {
  flake.modules.homeManager.atuin = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/atuin"]; # history db, encryption key, session
    };

    programs.atuin = {
      enable = true;

      # Keep fish's native up-arrow (previous command straight onto the line,
      # prefix-filtered — pre-atuin muscle memory); Ctrl-R still opens atuin.
      flags = ["--disable-up-arrow"];

      settings = {
        # Compact panel under the prompt instead of fullscreen UI
        inline_height = 20;
      };
    };
  };
}

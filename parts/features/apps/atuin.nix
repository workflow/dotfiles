{...}: {
  flake.modules.homeManager.atuin = {lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/atuin"]; # history db, encryption key, session
    };

    programs.atuin = {
      enable = true;

      settings = {
        # Up-arrow searches only the current session (stock-fish muscle memory);
        # Ctrl-R still searches the full global history.
        filter_mode_shell_up_key_binding = "session";

        # Compact panel under the prompt instead of fullscreen UI
        inline_height = 20;
      };
    };
  };
}

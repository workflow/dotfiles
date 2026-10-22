{...}: {
  flake.modules.homeManager.aichat = {
    osConfig,
    lib,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/aichat"
      ];
    };

    programs.aichat = {
      enable = true;
      settings = {
        keybindings = "vi";
        save_session = true;
        compress_threshold = 0;
      };
    };
  };
}

{...}: {
  flake.modules.homeManager.opencode = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".local/share/opencode"];
    };

    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      settings = {
        model = "zai-coding-plan/glm-5.2";
        small_model = "zai-coding-plan/glm-5-turbo";
        disabled_providers = ["zai"];
      };
    };
  };
}

{...}: {
  flake.modules.homeManager.opencode = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: let
    allowRules = lib.listToAttrs (lib.concatMap (prefix: [
        {
          name = prefix;
          value = "allow";
        }
        {
          name = "${prefix} *";
          value = "allow";
        }
      ])
      config.dendrix.agents.shellAllowlist);
    denyRules = lib.genAttrs config.dendrix.agents.shellDenylist (_: "deny");
  in {
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
        permission.bash = {"*" = "ask";} // allowRules // denyRules;
      };
    };
  };
}

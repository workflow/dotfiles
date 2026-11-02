{...}: {
  flake.modules.homeManager.slack = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/Slack"
      ];
    };

    home.packages = [
      pkgs.slack
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/slack" = ["slack.desktop"];
    };
  };
}

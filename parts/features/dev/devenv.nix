# devenv.sh
{...}: {
  flake.modules.homeManager.devenv = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/devenv"
      ];
    };

    home.packages = [
      pkgs.devenv
    ];

    # Auto-activate the devenv environment on directory change.
    programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable (
      lib.mkAfter "devenv hook fish | source"
    );
  };
}

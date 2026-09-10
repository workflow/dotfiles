# devenv.sh
{...}: {
  flake.modules.homeManager.devenv = {
    osConfig,
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

    # Activation happens in-place via direnv (`use devenv` in each project's
    # .envrc): devenv 2.x's fish hook wraps the shell in a pty proxy that
    # hides agents from herdr and needed caller-pwd workarounds.
  };
}

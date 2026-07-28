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
      lib.mkAfter ''
        devenv hook fish | source

        # devenv's hook cds to the project root before running `devenv shell`,
        # dropping the subdirectory that triggered activation. Export that
        # directory around activation so the spawned shell can cd back (below).
        if functions -q _devenv_hook
            functions -c _devenv_hook __devenv_hook_unwrapped
            function _devenv_hook --on-variable PWD
                set -gx _DEVENV_HOOK_CALLER_PWD $PWD
                __devenv_hook_unwrapped
                set -e _DEVENV_HOOK_CALLER_PWD
            end
        end
        if functions -q _devenv_hook_prompt
            functions -c _devenv_hook_prompt __devenv_hook_prompt_unwrapped
            function _devenv_hook_prompt --on-event fish_prompt
                set -gx _DEVENV_HOOK_CALLER_PWD $PWD
                __devenv_hook_prompt_unwrapped
                set -e _DEVENV_HOOK_CALLER_PWD
            end
        end

        # Inside a hook-spawned devenv shell: return to the caller's directory.
        if test -n "$_DEVENV_HOOK_DIR" -a -n "$DEVENV_ROOT" -a -n "$_DEVENV_HOOK_CALLER_PWD"
            set -l __devenv_caller_pwd $_DEVENV_HOOK_CALLER_PWD
            set -e _DEVENV_HOOK_CALLER_PWD
            test -d "$__devenv_caller_pwd"; and builtin cd "$__devenv_caller_pwd"
        end
      ''
    );
  };
}

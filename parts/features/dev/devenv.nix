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
                if test -n "$_DEVENV_HOOK_DIR" -a -n "$DEVENV_ROOT"
                    # Inside a hook-spawned shell the hook only guards leaving
                    # the project (and may `exit` mid-call): don't capture.
                    __devenv_hook_unwrapped
                else
                    set -gx _DEVENV_HOOK_CALLER_PWD $PWD
                    __devenv_hook_unwrapped
                    set -e _DEVENV_HOOK_CALLER_PWD
                end
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

        # Inside a hook-spawned devenv shell: return to the caller's directory,
        # rebased onto $DEVENV_ROOT. The caller may have entered through a
        # symlinked alias of the project (e.g. ~/nixos-config); a $PWD outside
        # $DEVENV_ROOT trips devenv's string-prefix leave-project guard, which
        # exits the shell and re-activates in a loop.
        if test -n "$_DEVENV_HOOK_DIR" -a -n "$DEVENV_ROOT" -a -n "$_DEVENV_HOOK_CALLER_PWD"
            set -l __devenv_caller (path resolve -- $_DEVENV_HOOK_CALLER_PWD)
            set -e _DEVENV_HOOK_CALLER_PWD
            set -l __devenv_root (path resolve -- $DEVENV_ROOT)
            if string match -q -- "$__devenv_root/*" $__devenv_caller
                set -l __devenv_target $DEVENV_ROOT(string replace -- $__devenv_root "" $__devenv_caller)
                test -d "$__devenv_target"; and builtin cd $__devenv_target
            end
        end
      ''
    );
  };
}

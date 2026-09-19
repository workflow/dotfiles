# herdr tracks a pane's cwd from the shell's OSC 7 report, but rejects reports
# whose file:// URI carries a hostname (herdrdev/herdr#3256), which is what
# stock fish emits. Without an accepted report herdr only has the shell's
# /proc cwd, which is gone by the time the shutdown snapshot is written, so
# restores fall back to the pane's spawn directory. Defining the function
# before __fish_config_interactive runs makes fish keep this variant, which
# omits the host.
if test "$HERDR_ENV" = 1
    function __fish_update_cwd_osc --description 'Report $PWD to herdr via OSC 7 without a hostname' \
        --on-variable=PWD --on-event=fish_prompt
        printf \e\]7\;file://%s\a (string escape --style=url -- $PWD)
    end
end

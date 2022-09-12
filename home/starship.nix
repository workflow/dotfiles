{ config, lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$directory"
        "$vcsh"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$buf"
        "$c"
        "$cmake"
        "$cobol"
        "$container"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$golang"
        "$haskell"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$nix_shell"
        "$conda"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$kubernetes"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];

      aws = {
        disabled = true;
      };

      gcloud = {
        format = "on [$symbol$account(@$domain)|($project)](green) ";
      };

      kubernetes = {
        disabled = false;
        style = "green";
        context_aliases = {
          "gke_northbound-staging_southamerica-east1-c_cluster-1" = "staging";
          "gke_northbound-prod_southamerica-east1-c_cluster-1" = "prod";
        };
      };

      status = {
        disabled = false;
        symbol = "🔴 ";
      };

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        impure_msg = "";
      };
    };

  };
}

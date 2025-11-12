{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".cache/starship"
    ];
  };

  programs.starship = {
    enable = true;

    enableTransience = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$directory"
        "$vcsh"
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
        disabled = true;
        format = "on [$symbol$account(@$domain)|($project)](green) ";
      };

      kubernetes = {
        disabled = false;
        style = "green";
        contexts = [
          {
            "context_pattern" = "kind-kind";
            "context_alias" = "kind";
          }
        ];
      };

      shell = {
        disabled = false;
        fish_indicator = "🐟";
        bash_indicator = "💩";
        nu_indicator = "🦀";
      };

      status = {
        disabled = false;
        map_symbol = true;
        pipestatus = false;
      };

      nix_shell = {
        disabled = true;
        format = "via [$symbol$state]($style) ";
        impure_msg = "";
      };
    };
  };
}

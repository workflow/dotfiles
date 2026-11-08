{...}: {
  flake.modules.homeManager.starship = {
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".cache/starship"];
    };

    programs.starship = {
      enable = true;
      enableTransience = true;
      # TODO: drop on the nixos-26.11 upgrade. jj_* modules need starship >= 1.27.0, 26.05 ships 1.25.1.
      package = pkgs.unstable.starship;

      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$singularity"
          "$directory"
          "$vcsh"
          "$vcs"
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

        vcs.order = ["jj" "git"];
        jj_status.style = "yellow";

        aws.disabled = true;

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
  };
}

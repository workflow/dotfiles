{ config, lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableFishIntegration = true;

    settings = {
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

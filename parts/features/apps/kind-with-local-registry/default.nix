{...}: {
  flake.modules.homeManager.kind-with-local-registry = {pkgs, ...}: let
    kind-with-local-registry = pkgs.writers.writeBashBin "kind-with-local-registry" (
      builtins.readFile ./_scripts/kind-with-local-registry.sh
    );
  in {
    home.packages = [kind-with-local-registry];
  };
}

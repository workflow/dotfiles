# Local registry for faster image iteration, i.e. with Skaffold
# To use local registry, prefix images with localhost:5001/ and make sure `docker push` is enabled
# See https://kind.sigs.k8s.io/docs/user/local-registry/
{pkgs, ...}: let
  kind-with-local-registry = pkgs.writers.writeBashBin "kind-with-local-registry" (
    builtins.readFile ./scripts/kind-with-local-registry.sh
  );
in {
  home.packages = [kind-with-local-registry];
}

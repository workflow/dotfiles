{ pkgs ? import <nixpkgs> {} }:

{

  # https://github.com/grahamc/nixos-config/blob/master/packages/mutate/default.nix
  template = script: args:
    pkgs.stdenvNoCC.mkDerivation (
      args // {
        name = baseNameOf script;
        phases = [ "installPhase" ];
        installPhase = ''
          cp ${script} $out
          substituteAllInPlace $out
          patchShebangs $out
        '';
      }
    );

}

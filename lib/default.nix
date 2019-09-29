{ pkgs ? import <nixpkgs> { } }:

{

  shellScript = scriptName: scriptText:
    let
      script = pkgs.writeScriptBin scriptName scriptText;
      shell = pkgs.mkShell { buildInputs = [ script ]; };
    in if pkgs.lib.inNixShell then shell else script;

  # https://github.com/grahamc/nixos-config/blob/master/packages/mutate/default.nix
  template = script: args:
    pkgs.stdenvNoCC.mkDerivation (args // {
      name = baseNameOf script;
      phases = [ "installPhase" ];
      installPhase = ''
        cp ${script} $out
        substituteAllInPlace $out
        patchShebangs $out
      '';
    });

}

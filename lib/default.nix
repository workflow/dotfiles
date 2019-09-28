{ pkgs ? import <nixpkgs> {} }:

{

  shellScript = scriptName: scriptText:
    let
      script = pkgs.writeScriptBin scriptName scriptText;
      shell = pkgs.mkShell {
        buildInputs = [ script ];
      };
    in
      if pkgs.lib.inNixShell then shell else script;

}

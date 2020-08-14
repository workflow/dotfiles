{ pkgs }:

pkgs.python3.pkgs.buildPythonApplication rec {
  name = "nix-sysdig";
  src = ./.;
  buildInputs = [ pkgs.makeWrapper ];
  checkInputs = [ pkgs.mypy ];
  checkPhase = ''
    mypy nix_sysdig
  '';
  makeWrapperArgs = [
    "--prefix PATH"
    ":"
    "${pkgs.sysdig}/bin"
  ];
}

{ pkgs ? import <nixpkgs> { } }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "pydf";
  version = "12";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "7f47a7c3abfceb1ac04fc009ded538df1ae449c31203962a1471a4eb3bf21439";
  };

  meta = with pkgs.stdenv.lib; {
    description = "colourised df(1)-clone";
    homepage = "http://kassiopeia.juls.savba.sk/~garabik/software/pydf/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ monsieurp ];
  };
}

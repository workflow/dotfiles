{ pkgs ? import <nixpkgs> {}, overrides ? {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    # rev = "ca8cb0474a807a39aaf0c10b4317cba153e8286f";
    # sha256 = "0ajyvhbq1czdn216bljvjs8ydkzfbaaf809r8yg187av9j7hsbhr";
    rev = "d1c7606cab89461de7a33e6a67af1fd60881737f";
    sha256 = "00kwpl7b4bsj9dzrml5mvqp886p5pprnmwz9bppasqwgdgimvgh5";
  };

in
pkgs.haskellPackages.callCabal2nix "ormolu" src overrides

{ pkgs ? import <nixpkgs> {} }:

let

  emacs-27-0-50 = {
    rev = "ef0fc0bed1c97a1c803fa83bee438ca9cfd238b0";
    sha256 = "0jv9vh9hrx9svdy0jz6zyz3ylmw7sbf0xbk7i80yxbbia2j8k9j2";
  };

  emacs-27-0-90 = {
    rev = "d096bab78750634301ff3c168e9bbbe9b52575d5";
    sha256 = "1bimad53lb33cgxqs2gbwfq0i0cphcqh7cp9149j7y6av28v5nqc";
  };

  src = {
    url = "https://github.com/emacs-mirror/emacs.git";
    fetchSubmodules = false;
  } // emacs-27-0-90;

  emacs = pkgs.emacs.overrideAttrs (
    old: {
      src = pkgs.fetchgit src;
      patches = [];
      version = "27";
      name = "emacs-27";
    }
  );

in
emacs.override { srcRepo = true; }

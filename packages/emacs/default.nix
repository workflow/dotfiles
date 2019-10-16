{ pkgs ? import <nixpkgs> { } }:

let

  emacs = pkgs.emacs.overrideAttrs (old: {
    src = pkgs.fetchgit {
      url = "https://github.com/emacs-mirror/emacs.git";
      rev = "ef0fc0bed1c97a1c803fa83bee438ca9cfd238b0";
      sha256 = "0jv9vh9hrx9svdy0jz6zyz3ylmw7sbf0xbk7i80yxbbia2j8k9j2";
      fetchSubmodules = false;
    };
    patches = [ ];
    version = "27";
    name = "emacs-27";
  });

in emacs.override { srcRepo = true; }

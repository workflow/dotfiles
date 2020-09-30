{ source ? import ./nix/sources.nix
, system ? builtins.currentSystem
,
}:
let
  pkgs = import source.nixpkgs-unstable {
    inherit system;
    overlays = [
      (import "${source.nixpkgs-mozilla}/rust-overlay.nix")
    ];
  };
  rust = pkgs.latest.rustChannels.nightly.rust;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    rust
    pre-commit
  ];
}

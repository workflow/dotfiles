{...}: {
  flake.modules.nixos.nix-ld = {...}: {
    programs.nix-ld.enable = true;
  };
}

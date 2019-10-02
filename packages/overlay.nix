{ }:
self: super:

{
  emacs-27 = super.callPackage ./emacs { };

  nixfmt = super.callPackage ./tools/nixfmt.nix { };
  pydf = super.callPackage ./tools/pydf.nix { };

  kbconfig = super.callPackage ./scripts/kbconfig.nix { };
  i3lock-wrap = super.callPackage ./scripts/i3lock-wrap { };
}

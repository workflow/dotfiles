# NixOS 26.05 Upgrade Adventures

> _Yarara_: South American pit viper. Strikes fast, lingers in the underbrush.

[Release notes — NixOS 26.05](https://nixos.org/manual/nixos/stable/release-notes#sec-release-26.05)

## The i686 openblas deadlock

Build hung for hours every time at `checkPhase` test #28 (xzcblat2 → xzcblat3 deadlock).

Diagnosis path that actually worked:

1. **Multiple drvs, same name.** Closure had four `openblas-0.3.33.drv` files, each with different output paths. `nix-store --query --outputs` showed they're all multi-output (`out` + `dev`). Three were x86_64; one was **i686**.
2. **Cache miss only on the i686 variant.** `cache.nixos.org` 200 for the three x86_64 outputs, 404 for both i686 outputs. `cache.flakehub.com` 401, `niri.cachix.org` 404. Hydra simply hadn't published an i686 binary for this nixpkgs rev.
3. **`nix-store --query --referrers` traced it back** to `serf → scons → numpy → openblas` in the 32-bit pkgs set. The 32-bit chain comes from `programs.steam.enable = true` combined with `hardware.graphics.enable32Bit = true`.
4. **The checkPhase deadlock is CPU-specific.** Hydra builds at scale never hit it, so when the binary _is_ cached, this is invisible. We only saw it because the cache miss forced a local build.

Fix in `parts/features/apps/steam.nix` — overlay scoped to the i686 variant only:

```nix
nixpkgs.overlays = [
  (_: prev: {
    pkgsi686Linux = prev.pkgsi686Linux.extend (_: superI: {
      openblas = superI.openblas.overrideAttrs (_: {
        doCheck = false;
        doInstallCheck = false;
      });
    });
  })
];
```

### Things that wasted time before landing on the real fix

- `nix-store --realise <outPath>` only fetches that one output. A multi-output drv where _any_ output is missing forces Nix to rebuild the whole drv. The `^*` syntax (`drv.drv^*`) to grab all outputs isn't supported on this Nix version — substitute each `outPath` explicitly instead.
- Eval-time `outPath` matching the cached one doesn't mean the build will skip. Three of the four drvs in the closure had matching cached outPaths; the fourth (i686) didn't, and that's what blocked.
- The trace was just `openblas-0.3.33 (checkPhase)` without a drv hash. `nix-store --query --outputs` on every `*-openblas-0.3.33.drv` in `/nix/store` + checking which outputs were missing locally vs. cached was the fastest way to identify which variant was actually being built.

## Links

- [Release notes (upstream)](https://nixos.org/manual/nixos/stable/release-notes#sec-release-26.05)
- [NixOS 24.11 Upgrade Adventures](/doc/upgrades/2411/NixOS-24.11.md)
- [NixOS 24.05 Upgrade Adventures](/doc/upgrades/2405/NixOS-24.05.md)
- [NixOS Upgrade Checklist](/doc/upgrades/Checklist.md)

{pkgs, ...}: let
  # Wrap Hoppscotch with Wayland-friendly flags
  hoppscotch-wrapped = pkgs.symlinkJoin {
    name = "hoppscotch-wrapped";
    paths = [pkgs.unstable.hoppscotch];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/hoppscotch \
        --set NIXOS_OZONE_WL 1 \
        --add-flags "--use-gl=desktop" \
        --add-flags "--disable-gpu-sandbox"
    '';
  };
in {
  home.packages = [
    hoppscotch-wrapped
  ];
}

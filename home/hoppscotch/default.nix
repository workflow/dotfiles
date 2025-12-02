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
  home.persistence."/persist".directories = [
    ".local/share/io.hoppscotch.desktop" # Auth tokens, collections, requests, workspaces
    ".config/io.hoppscotch.desktop" # App settings, bundles, window state
  ];

  home.packages = [
    hoppscotch-wrapped
  ];
}

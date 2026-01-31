{...}: {
  flake.modules.homeManager.hoppscotch = {pkgs, ...}: let
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
      ".local/share/io.hoppscotch.desktop"
      ".config/io.hoppscotch.desktop"
    ];

    home.packages = [hoppscotch-wrapped];
  };
}

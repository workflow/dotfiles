{ pkgs }:

let

  scripts = pkgs.callPackage ./scripts.nix {};

  mkAutostart = name: script:
    let
      drv = pkgs.writeScriptBin "autostart-${name}" script;
    in
      ''
        [Desktop Entry]
        Encoding=UTF-8
        Type=Application
        OnlyShowIn=XFCE;
        StartupNotify=false
        Terminal=false
        Hidden=false
        Name=${name}
        Comment=${name}
        Exec=${drv}/bin/autostart-${name}
      '';

in

{
  xmonad-init = mkAutostart "xmonad-init" scripts.xmonad-init;
}

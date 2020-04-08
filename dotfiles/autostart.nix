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
        Version=0.9.4
        Type=Application
        Name=${name}
        Comment=${name}
        Exec=${drv}/bin/autostart-${name}
        OnlyShowIn=XFCE;
        StartupNotify=false
        Terminal=false
        Hidden=false
      '';

in

{
  xmonad-init = mkAutostart "xmonad-init" scripts.xmonad-init;
}

{ pkgs }:

{
  xfce-init = ''
    [Desktop Entry]
    Encoding=UTF-8
    Version=0.9.4
    Type=Application
    Name=xfce-init
    Comment=xfce-init
    Exec=/home/alex/bin/xfce-init
    OnlyShowIn=XFCE;
    StartupNotify=false
    Terminal=false
    Hidden=false
  '';
}

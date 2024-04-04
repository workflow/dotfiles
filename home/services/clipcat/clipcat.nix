{ pkgs, ... }:
### Clipcat service itself is system-wide, currently not supported by HM
{
  xdg.configFile = {
    "clipcat/clipcatd.toml".source = ./clipcatd.toml;
    "clipcat/clipcatctl.toml".source = ./clipcatctl.toml;
    "clipcat/clipcat-menu.toml".source = ./clipcat-menu.toml;
  };

  home.packages = with pkgs; [
    clipcat
  ];
}

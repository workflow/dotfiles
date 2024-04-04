{ pkgs, ... }:
### Clipcat service itself is system-wide, currently not supported by HM
{
  xdg.configFile = {
    "clipcat/clipcatd.toml".source = ../../dotfiles/clipcat/clipcatd.toml;
    "clipcat/clipcatctl.toml".source = ../../dotfiles/clipcat/clipcatctl.toml;
    "clipcat/clipcat-menu.toml".source = ../../dotfiles/clipcat/clipcat-menu.toml;
  };

  home.packages = with pkgs; [
    clipcat
  ];
}

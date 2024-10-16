{
  isHidpi,
  isPpiScaledOnePointFive,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size =
        if isHidpi
        then 48
        else if isPpiScaledOnePointFive
        then 36
        else 24;
    };
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      sizes = {
        applications = 9;
        desktop = 9;
        terminal = 8;
        popups = 9;
      };
    };
    image = /home/farlion/Pictures/Backgrounds/costa_9_mountain_desk.jpg;
    polarity = "dark";
  };
}

{
  lib,
  isImpermanent,
  pkgs,
  ...
}: let
  # Looted from https://gist.github.com/elijahmanor/c10e5787bf9ac6b8c276e47e6745826c, much obliged
  font-smoke-test = pkgs.writers.writeBashBin "font-smoke-test" ''
    set -e

    printf "%b\n" "Normal"
    printf "%b\n" "\033[1mBold\033[22m"
    printf "%b\n" "\033[3mItalic\033[23m"
    printf "%b\n" "\033[3;1mBold Italic\033[0m"
    printf "%b\n" "\033[4mUnderline\033[24m"
    printf "%b\n" "== === !== >= <= =>"
    printf "%b\n" "     󰾆      󱑥 󰒲 󰗼"
  '';
in {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/home/farlion/.cache/fontconfig"
    ];
  };

  environment.systemPackages = [font-smoke-test];

  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.dejavu_fonts
      pkgs.font-awesome_4
      pkgs.font-awesome_5
      pkgs.font-awesome_6
      (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
      pkgs.noto-fonts-color-emoji # emoji font
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["DejaVu Sans"];
        serif = ["DejaVu Serif"];
        monospace = ["Fira Code"];
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  # Looted from https://gist.github.com/elijahmanor/c10e5787bf9ac6b8c276e47e6745826c, much obliged
  fontSmokeTest = pkgs.writers.writeBashBin "font-smoke-test" ''
    set -e

    printf "%b\n" "Normal"
    printf "%b\n" "\033[1mBold\033[22m"
    printf "%b\n" "\033[3mItalic\033[23m"
    printf "%b\n" "\033[3;1mBold Italic\033[0m"
    printf "%b\n" "\033[4mUnderline\033[24m"
    printf "%b\n" "== === !== >= <= =>"
    printf "%b\n" "     󰾆      󱑥 󰒲 󰗼"
  '';
  # Patch Fira Code with Nerd Fonts plus local Font Awesome 6 Pro glyphs into ~/.local/share/fonts
  patchFiraWithFA6Pro = pkgs.writeShellApplication {
    name = "patch-fira-with-fa6-pro";
    runtimeInputs = [
      pkgs.fira-code
      pkgs.fontforge
      pkgs.findutils
      pkgs.coreutils
      pkgs.fontconfig
      pkgs.nerd-font-patcher
    ];
    runtimeEnv = {
      SRC_DIR = "${pkgs.fira-code}/share/fonts/truetype";
    };
    text = builtins.readFile ./scripts/patch-fira-with-fa6-pro.sh;
  };
in {
  home-manager.users.farlion.home.persistence."/persist" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/share/fonts" # Locally persisted fonts (not nixos-managed)
      ".cache/fontconfig" # Fontconfig cache
    ];
  };

  environment.systemPackages = [
    fontSmokeTest
    patchFiraWithFA6Pro
  ];

  # Run the patcher during Home Manager activation so that fonts are ready after switch
  home-manager.users.farlion.home.activation.patchFiraWithFA6Pro = ''
    OUT_DIR="$HOME/.local/share/fonts/NerdPatched/FiraCodeFAPro"
    if [ ! -d "$OUT_DIR" ] || [ -z "$(ls -A "$OUT_DIR" 2>/dev/null)" ]; then
      echo "[patch-fira-with-fa6-pro] Patched fonts not found or directory empty, running patcher..."
      "${patchFiraWithFA6Pro}/bin/patch-fira-with-fa6-pro"
    else
      echo "[patch-fira-with-fa6-pro] Patched fonts already exist in $OUT_DIR, skipping..."
    fi
  '';

  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.dejavu_fonts
      pkgs.font-awesome_5
      pkgs.font-awesome_6
      pkgs.unstable.font-awesome
      pkgs.noto-fonts-color-emoji # emoji font
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["DejaVu Sans"];
        serif = ["DejaVu Serif"];
        monospace = ["FiraCode Nerd Font" "Fira Code"];
      };
    };
  };
}

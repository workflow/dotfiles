{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.fonts = {pkgs, ...}: let
    fontSmokeTest = pkgs.writers.writeBashBin "font-smoke-test" ''
      set -e

      printf "%b\n" "Normal"
      printf "%b\n" "\033[1mBold\033[22m"
      printf "%b\n" "\033[3mItalic\033[23m"
      printf "%b\n" "\033[3;1mBold Italic\033[0m"
      printf "%b\n" "\033[4mUnderline\033[24m"
      printf "%b\n" "== === !== >= <= =>"
      printf "%b\n" "     󰾆      󱑥 󰒲 󰗼"
    '';
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
      text = builtins.readFile ./_scripts/patch-fira-with-fa6-pro.sh;
    };
  in {
    environment.systemPackages = [
      fontSmokeTest
      patchFiraWithFA6Pro
    ];

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
        pkgs.noto-fonts-color-emoji
      ];
      fontconfig = {
        defaultFonts = {
          sansSerif = ["DejaVu Sans"];
          serif = ["DejaVu Serif"];
          monospace = ["FiraCode Nerd Font" "Fira Code"];
        };
      };
    };
  };

  flake.modules.homeManager.fonts = {lib, ...}: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/share/fonts"
        ".cache/fontconfig"
      ];
    };
  };
}

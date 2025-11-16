{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".claude" # Claude Code global settings, agents, and credentials
    ];
  };

  home.packages = with pkgs.unstable; [claude-code];

  # See https://dylancastillo.co/til/fix-claude-code-shift-enter-alacritty.html
  programs.alacritty.settings.keyboard.bindings = [
    {
      key = "Return";
      mods = "Shift";
      chars = "\n";
    }
  ];
}

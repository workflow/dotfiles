{pkgs, ...}:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vintage-filter
    ];
  };
}

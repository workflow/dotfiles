{...}: {
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };
}

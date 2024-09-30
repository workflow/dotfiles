{...}: {
  programs.firefox = {
    enable = true;
    profiles = {
      main = {
        id = 0;
        isDefault = true;
      };
    };
  };
}

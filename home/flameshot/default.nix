{...}: {
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        copyPathAfterSave = true;
        disabledTrayIcon = true;
      };
    };
  };
}

{...}: {
  services.logrotate = {
    enable = true;

    # Nvim LSP Log (tends to grow too quickly)
    settings."/home/farlion/.local/state/nvim/lsp.log" = {
      size = "1M";
      rotate = 5; # keep 5 old logs
      compress = true;
      copytruncate = true; # since nvim may keep the file open
      missingok = true;
      notifempty = true;
      su = "farlion users";
      create = "0640 farlion users";
      frequency = "hourly";
    };
  };
}

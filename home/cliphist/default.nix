{...}: {
  services.cliphist = {
    enable = true;
    systemdTarget = "sway-session.target";
  };
}

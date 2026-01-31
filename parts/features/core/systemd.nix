{...}: {
  flake.modules.nixos.systemd = {...}: {
    systemd.enableStrictShellChecks = true;
  };
}

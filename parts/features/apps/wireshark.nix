{...}: {
  flake.modules.nixos.wireshark = {pkgs, ...}: {
    environment.systemPackages = [pkgs.wireshark];
    programs.wireshark.enable = true;
    users.users.farlion.extraGroups = ["wireshark"];
  };
}

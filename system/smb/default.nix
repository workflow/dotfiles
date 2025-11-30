{pkgs, ...}: {
  boot.supportedFilesystems = ["cifs"];
  environment.systemPackages = [pkgs.cifs-utils];
}

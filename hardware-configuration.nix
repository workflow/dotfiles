{ lib, ... }:

{
  imports = [ <nixos-hardware/common/pc/laptop/acpi_call.nix> ];

  hardware.brightnessctl.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

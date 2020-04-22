{ lib, ... }:

{
  imports = [ <nixos-hardware/common/pc/laptop/acpi_call.nix> ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

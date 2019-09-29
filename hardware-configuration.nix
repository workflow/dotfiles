{ ... }:

{
  imports = [ <nixos-hardware/common/pc/laptop/acpi_call.nix> ];

  hardware.brightnessctl.enable = true;
}

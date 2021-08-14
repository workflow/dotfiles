{ pkgs, ... }:
let

  #tpacpi-bat = pkgs.callPackage ../packages/tools/tpacpi-bat.nix {};

in
{

  #services.tlp = {
  #  enable = true;
  #  extraConfig = ''
  #    TLP_DEFAULT_MODE=AC
  #    TLP_PERSISTENT_DEFAULT=0
  #    DISK_IDLE_SECS_ON_AC=0
  #    DISK_IDLE_SECS_ON_BAT=2
  #    MAX_LOST_WORK_SECS_ON_AC=15
  #    MAX_LOST_WORK_SECS_ON_BAT=60
  #    CPU_HWP_ON_AC=balance_performance
  #    CPU_HWP_ON_BAT=balance_power
  #    SCHED_POWERSAVE_ON_AC=0
  #    SCHED_POWERSAVE_ON_BAT=1
  #    NMI_WATCHDOG=0
  #    ENERGY_PERF_POLICY_ON_AC=performance
  #    ENERGY_PERF_POLICY_ON_BAT=power
  #    DISK_DEVICES="sda sdb"
  #    DISK_APM_LEVEL_ON_AC="254 254"
  #    DISK_APM_LEVEL_ON_BAT="128 128"
  #    SATA_LINKPWR_ON_AC="med_power_with_dipm max_performance"
  #    SATA_LINKPWR_ON_BAT="med_power_with_dipm min_power"
  #    PCIE_ASPM_ON_AC=performance
  #    PCIE_ASPM_ON_BAT=powersave
  #    RADEON_POWER_PROFILE_ON_AC=high
  #    RADEON_POWER_PROFILE_ON_BAT=low
  #    RADEON_DPM_STATE_ON_AC=performance
  #    RADEON_DPM_STATE_ON_BAT=battery
  #    RADEON_DPM_PERF_LEVEL_ON_AC=auto
  #    RADEON_DPM_PERF_LEVEL_ON_BAT=auto
  #    WIFI_PWR_ON_AC=off
  #    WIFI_PWR_ON_BAT=on
  #    WOL_DISABLE=Y
  #    SOUND_POWER_SAVE_ON_AC=0
  #    SOUND_POWER_SAVE_ON_BAT=1
  #    SOUND_POWER_SAVE_CONTROLLER=Y
  #    BAY_POWEROFF_ON_AC=0
  #    BAY_POWEROFF_ON_BAT=0
  #    BAY_DEVICE="sr0"
  #    RUNTIME_PM_ON_AC=on
  #    RUNTIME_PM_ON_BAT=auto
  #    USB_AUTOSUSPEND=0
  #    RESTORE_DEVICE_STATE_ON_STARTUP=0
  #  '';
  #};

  #services.acpid.acEventCommands = ''
  #  echo -1 > /sys/module/usbcore/parameters/autosuspend
  #'';

  #environment.systemPackages = [ tpacpi-bat ];

  # This will save you money and possibly your life!
  services.thermald.enable = true;

  # DPMS Settings, see https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
  services.xserver.serverFlagsSection = ''
    Option "BlankTime" "0"
    Option "StandbyTime" "600"
    Option "SuspendTime" "1200"
    Option "OffTime" "1800"
  '';

}

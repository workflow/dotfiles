# Proves the root-explode unit ordering never runs on resume from hibernation.
# Mirrors numenor: systemd initrd, EFI, no resume= on the cmdline, so systemd resumes via the HibernateLocation EFI variable.
# Modelled on nixpkgs' nixos/tests/hibernate.nix. Instead of wiping, a canary marks a raw disk whenever the unit runs.
{
  pkgs,
  mkRootExplodeService,
}:
pkgs.testers.runNixOSTest {
  name = "root-explode-hibernate-resume";

  nodes.machine = {
    config,
    lib,
    utils,
    ...
  }: {
    powerManagement.powerDownCommands = "systemctl --no-block stop backdoor.service";
    powerManagement.resumeCommands = "systemctl --no-block restart backdoor.service";

    boot.initrd.systemd.enable = true;
    virtualisation.useEFIBoot = true;
    virtualisation.useNixStoreImage = true;
    virtualisation.fileSystems."/".autoFormat = true;
    # vdc: swap, vdd: 1 MiB canary disk
    virtualisation.emptyDiskImages = [(2 * config.virtualisation.memorySize) 1];
    swapDevices = lib.mkOverride 0 [
      {
        device = "/dev/vdc";
        options = ["x-systemd.makefs"];
      }
    ];

    boot.initrd.systemd.services.root-explode = mkRootExplodeService {
      inherit utils;
      device = config.virtualisation.rootDevice;
      script = ''
        echo "root-explode canary ran" >/dev/kmsg
        printf ran | dd of=/dev/vdd oflag=direct,sync bs=512 conv=sync status=none
      '';
    };
  };

  testScript = ''
    def canary():
        return machine.succeed("dd if=/dev/vdd iflag=direct bs=512 count=1 status=none | tr -d '\\0'").strip()

    def reset_canary():
        machine.succeed("dd if=/dev/zero of=/dev/vdd oflag=direct,sync bs=512 count=1 status=none")

    machine.wait_for_unit("default.target")
    machine.succeed("test $(blockdev --getsize64 /dev/vdd) -eq 1048576")

    with subtest("unit runs on a cold boot"):
        assert canary() == "ran", canary()

    with subtest("unit never runs when resuming from hibernation"):
        reset_canary()
        machine.succeed(
            "mkdir /run/test",
            "mount -t ramfs -o size=1m ramfs /run/test",
            "echo not persisted to disk > /run/test/suspended",
        )
        machine.execute("systemctl hibernate >&2 &", check_return=False)
        machine.wait_for_shutdown()
        machine.start()
        machine.succeed("grep 'not persisted to disk' /run/test/suspended")
        assert canary() == "", canary()

    with subtest("unit runs again on the next cold boot"):
        machine.crash()
        machine.wait_for_unit("default.target")
        machine.fail("grep 'not persisted to disk' /run/test/suspended")
        assert canary() == "ran", canary()
  '';
}

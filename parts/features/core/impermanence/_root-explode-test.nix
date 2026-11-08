# Runs scripts/root-explode.sh against a scratch btrfs disk, in the same strict mode the initrd uses.
# The script relies on PATH like it does in the initrd, so the tools come from systemPackages.
{
  pkgs,
  rootExplodeScript,
}:
pkgs.testers.runNixOSTest {
  name = "root-explode";

  nodes.machine = {
    virtualisation.emptyDiskImages = [1024];
    environment.systemPackages = [
      pkgs.btrfs-progs
      (pkgs.writeShellApplication {
        name = "root-explode";
        text = rootExplodeScript;
      })
    ];
  };

  testScript = ''
    def explode(path_prefix=""):
        machine.succeed(f"{path_prefix}BTRFS_DEVICE=/dev/vdb root-explode")

    def assert_fresh_root():
        machine.succeed("btrfs subvolume show /top/root")
        machine.succeed("test -z \"$(ls -A /top/root)\"")

    def assert_persist_and_nix_intact():
        machine.succeed("grep -qx keep /top/persist/sentinel")
        machine.succeed("grep -qx keep /top/nix/sentinel")

    def archives():
        return machine.succeed("ls -A /top/persist/old_roots").split()

    def dirty_root():
        machine.succeed("echo junk > /top/root/junk")
        machine.succeed("mkdir -p /top/root/var/lib && btrfs subvolume create /top/root/var/lib/machines")

    def reset_old_roots():
        machine.succeed("for d in /top/persist/old_roots/*; do btrfs subvolume delete -R \"$d\" || rm -rf \"$d\"; done")

    machine.wait_for_unit("multi-user.target")
    machine.succeed("mkfs.btrfs -f /dev/vdb && mkdir /top && mount -o subvolid=5 /dev/vdb /top")
    machine.succeed("btrfs subvolume create /top/persist && echo keep > /top/persist/sentinel")
    machine.succeed("btrfs subvolume create /top/nix && echo keep > /top/nix/sentinel")

    with subtest("creates root on a fresh filesystem"):
        explode()
        assert_fresh_root()
        assert_persist_and_nix_intact()

    with subtest("archives the previous root including nested subvolumes"):
        dirty_root()
        explode()
        assert_fresh_root()
        [archive] = archives()
        machine.succeed(f"grep -qx junk /top/persist/old_roots/{archive}/junk")
        machine.succeed(f"btrfs subvolume show /top/persist/old_roots/{archive}/var/lib/machines")
        assert_persist_and_nix_intact()
        reset_old_roots()

    with subtest("never overwrites an archive with the same timestamp"):
        machine.succeed("btrfs subvolume create /top/persist/old_roots/2026-01-01_00:00:00")
        machine.succeed("echo earlier > /top/persist/old_roots/2026-01-01_00:00:00/marker")
        dirty_root()
        machine.succeed("touch -d '2026-01-01 00:00:00 UTC' /top/root")
        explode()
        assert_fresh_root()
        machine.succeed("grep -qx earlier /top/persist/old_roots/2026-01-01_00:00:00/marker")
        machine.succeed("grep -qx junk /top/persist/old_roots/2026-01-01_00:00:00.1/junk")
        reset_old_roots()

    with subtest("prunes stale archives, keeps fresh ones and skips non-subvolumes"):
        machine.succeed("btrfs subvolume create /top/persist/old_roots/stale")
        machine.succeed("btrfs subvolume create /top/persist/old_roots/stale/nested")
        machine.succeed("btrfs subvolume create /top/persist/old_roots/recent")
        machine.succeed("mkdir /top/persist/old_roots/plain")
        machine.succeed("touch -d '60 days ago' /top/persist/old_roots/stale /top/persist/old_roots/plain")
        machine.succeed("touch -d '1 day ago' /top/persist/old_roots/recent")
        dirty_root()
        machine.succeed("touch -d '60 days ago' /top/root")
        explode()
        assert_fresh_root()
        remaining = archives()
        assert "stale" not in remaining, remaining
        assert "recent" in remaining, remaining
        assert "plain" in remaining, remaining
        assert len(remaining) == 3, f"expected the archive of the 60 day old root to survive: {remaining}"
        assert_persist_and_nix_intact()
        reset_old_roots()

    with subtest("keeps persist and nix when root is missing and old_roots itself is stale"):
        machine.succeed("btrfs subvolume delete -R /top/root")
        machine.succeed("touch -d '60 days ago' /top/persist/old_roots")
        explode()
        assert_fresh_root()
        assert_persist_and_nix_intact()

    with subtest("puts the old root back when a new one can't be created"):
        machine.succeed("mkdir /shim && printf '%s\\n' '#!/bin/sh' '[ \"$1 $2\" = \"subvolume create\" ] && exit 1' 'exec ${pkgs.btrfs-progs}/bin/btrfs \"$@\"' > /shim/btrfs && chmod +x /shim/btrfs")
        dirty_root()
        machine.fail("PATH=/shim:$PATH BTRFS_DEVICE=/dev/vdb root-explode")
        machine.succeed("grep -qx junk /top/root/junk")
        assert archives() == [], archives()
        assert_persist_and_nix_intact()
  '';
}

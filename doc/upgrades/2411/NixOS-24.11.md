# NixOS 24.11 Upgrade Adventures

![Uakavolution](assets/uakavolution.webp)

# LLama Not-So-Drama Breakages

## Sound on the XPS 9700

A number of pipewire sinks and sources changed name on this hardware, so I had to adjust my hardcoded sound switcher and sound maintainer scripts.

Also the internal microphone stopped working.

This was due to the [Sound options removal](https://nixos.org/manual/nixos/stable/release-notes#sec-release-24.11-migration-sound) no longer persisting ALSA settings, which are needed to [get the internal mic working on the Dell XPS 9700.](https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2584286824)
The [Release Notes](https://nixos.org/manual/nixos/stable/release-notes#sec-release-24.11-migration-sound) suggest setting `hardware.alsa.enablePersistence = true;` however that setting [doesn't exist anymore](https://github.com/NixOS/nixpkgs/blob/release-22.11/nixos/modules/services/audio/alsa.nix#L25)?

Thankfully with NixOS it's super easy to go and look at the code of what that setting used to do:

```nix
environment.systemPackages = [ pkgs.alsa-utils ];
# ALSA provides a udev rule for restoring volume settings.
services.udev.packages = [ pkgs.alsa-utils ];
systemd.services.alsa-store =
  {
     description = "Store Sound Card State";
     wantedBy = [ "multi-user.target" ];
     unitConfig.RequiresMountsFor = "/var/lib/alsa";
     unitConfig.ConditionVirtualization = "!systemd-nspawn";
     serviceConfig = {
       Type = "oneshot";
       RemainAfterExit = true;
       ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
       ExecStop = "${pkgs.alsa-utils}/sbin/alsactl store --ignore";
      };
  };
```

An alternative to using persistence is to run `amixer --card 1 set 'rt715 ADC 24 Mux' 'DMIC3'` after every boot.

Which got me thinking, can Pipewire manipulate ALSA settings like this one? But I couldn't find a simple way.

## Impure home-manager Evaluation breaking Builds

```
nixos-rebuild build --flake .
building the system configuration...
warning: Git tree '/home/farlion/code/nixos-config' is dirty
error:
       … while calling the 'head' builtin
         at /nix/store/fz4h8yz3qr83p6cfhisgj02knjqg6nxs-source/lib/attrsets.nix:1574:11:
         1573|         || pred here (elemAt values 1) (head values) then
         1574|           head values
             |           ^
         1575|         else

       … while evaluating the attribute 'value'
         at /nix/store/fz4h8yz3qr83p6cfhisgj02knjqg6nxs-source/lib/modules.nix:816:9:
          815|     in warnDeprecation opt //
          816|       { value = addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          817|         inherit (res.defsFinal') highestPrio;

       … while evaluating the option `system.build.toplevel':

       … while evaluating definitions from `/nix/store/fz4h8yz3qr83p6cfhisgj02knjqg6nxs-source/nixos/modules/system/activation/top-level.nix':

       … while evaluating the option `assertions':

       … while evaluating definitions from `/nix/store/pq697d1bkix3hvrjkrxfhsa3zwykxkwb-source/nixos/common.nix':

       … while evaluating the option `home-manager.users.farlion.assertions':

       … while evaluating definitions from `/nix/store/pq697d1bkix3hvrjkrxfhsa3zwykxkwb-source/modules/programs/swaylock.nix':

       … while evaluating the option `home-manager.users.farlion.programs.swaylock.enable':

       … while evaluating the option `home-manager.users.farlion.programs.swaylock.settings':

       … while evaluating definitions from `/nix/store/1z9qs66gn7cx8f41y4qxbi56wyllvzbr-modules/swaylock/hm.nix':

       (stack trace truncated; use '--show-trace' to show the full, detailed trace)

       error: access to absolute path '/home' is forbidden in pure evaluation mode (use '--impure' to override)
```

This seemed to have been caused by [Stylix](https://github.com/danth/stylix) doing some assertions in the swaylock module 👀 but it was just a red herring. The actual culprit was that Stylix's `image` option, which is still mandatory (see https://github.com/danth/stylix/issues/200) apparently stopped being pured when fed an absolute path.
Fix: https://github.com/workflow/dotfiles/commit/c9a13ffeaf7f5e81012c3751426a797ef4d90a16

# Intriguing Changes

## nix flake update

`nix flake update` can now update single inputs - such as the `secrets` in this repo - which feels a lot more ergonomic than the previous `nix flake lock --update-input secrets`

## convertHash

This seems useful: https://nix.dev/manual/nix/2.25/language/builtins#builtins-convertHash

## Pipe Operators

https://github.com/NixOS/nix/pull/11131
🫶
Also watch https://www.youtube.com/watch?v=WOw8MJYZjRI

# Intriguing new Modules

## new `hardware.amdgpu` module

-> already migrated to

## `services.displayManager.ly`

TUI displaymanager!

## `systemd.enableStrictShellChecks`

https://nixos.org/manual/nixos/stable/options#opt-systemd.enableStrictShellChecks
let's test that

## soteria

https://github.com/ImVaskel/soteria a polkit authentication agent to handle elevated prompts for any desktop environment.
Interesting, might be worth using with i3.

## Firefly III Data Importer

Now available as `services.firefly-iii-data-importer`
Always wanted to try Firefly over pocketsmith.com, but I assume it's going to be quiiite a bit of migration work.

## Dashy

Homelab Dashboard sponsored by Umbrel

## pay-respects

`thefuck` + `command-not-found` written in Rust: https://codeberg.org/iff/pay-respects
Also available in home-manager, see below.

## HomeBox

An inventory and organization system built for the home user.

## evremap

New keyboard input remapper by wez written in Rust: https://github.com/wez/evremap

## Music Assistant

A music library manager for your offline and online music sources that can stream to a wide range of supported players
https://github.com/music-assistant/server

## Collabora Online

Online Libreoffice Collaboration Suite
https://www.collaboraonline.com/

## wg-access-server

Wireguard VPN solution with a WebGUI for authn and connecting devices
https://github.com/freifunkMUC/wg-access-server/

## pingvin-share

Open-Source self-hosted WeTransfer
https://github.com/stonith404/pingvin-share

## localsend

Already using, now has its own module under `programs.localsend`

## gatus

Automated developer-oriented status page
https://github.com/TwiN/gatus

## glance

Self-hosted Dashboard that puts all your feeds in one place
https://github.com/glanceapp/glance

## realm

Rust relay server
https://github.com/zhboner/realm

## rathole

Rust reverse-proxy for NAT traversal
https://github.com/rapiz1/rathole

## wakapi

Time-tracking for programmers
https://wakapi.dev/

## immich

High performance self-hosted photo and video management solution.
https://github.com/immich-app/immich

## obs-studio

Now has its own module: `programs.obs-studio`

## swapspace

A dynamic swap space manager that turns your unused free space into swap automatically.
Seems like an old project: https://github.com/Tookmund/Swapspace

## glances

top/btop alternative written in python that supports remote monitoring: https://github.com/nicolargo/glances

## automatic-timezoned

try it out at `services.automatic-timezoned.enable`

# Intriguing home-manager additions

## trayscale

An unofficial GUI wrapper around the Tailscale CLI client
https://github.com/DeedleFake/trayscale

## nh

Now has a home-manager module under `programs.nh`

## podman

Now available as HM module: `services.podman`

## nix-your-shell

`programs.nix-your-shell` provides a wrapper for `nix develop` to retain the same shell inside the new environment!

## pay-respects

Also availabe in HM now!

# Links

- [NixOS 24.05 Upgrade Adventures](doc/upgrades/2405/NixOS-24.05.md)
- [NixOS Upgrade Checklist](doc/upgrades/Checklist.md)

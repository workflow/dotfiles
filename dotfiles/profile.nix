{ pkgs }:

{
  path = [ "$HOME/bin" ];

  aliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    a = "autorandr --change";
    am = "autorandr mobile";
    as = "autorandr sophia";
    av = "autorandr movie";

    aliases = "vim ~/nixos-config/dotfiles/profile.nix";

    c = "xclip -selection clipboard";

    cdd = "cd ~/code/tenx/dataaccessserver";
    cdh = "cd ~/code/tenx/hyperion";
    cdn = "cd ~/nixos-config";
    cdc = "cd ~/code";
    cdt = "cd ~/code/tenx";

    d = ''
      echo -e 'power off\nquit' | bluetoothctl;
      pactl set-default-sink "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo"
    '';
    da = "direnv allow";

    freetapbeer = "nmcli c up 'Free Tap Beer'";

    g = "git";

    i = "vim ~/nixos-config/home/xsession/i3.nix";

    # TODO: Move these to git aliases
    ga = "git add -p";
    gaa = "git add --all";
    gaf = "git add -N";
    gc = "git checkout";
    gca = "git commit --amend";
    gcb = "git checkout -b";
    gd = "git diff";
    gdc = "git diff --cached";
    gf = "git fetch --prune";
    gfo = "git fetch origin master:master";
    gl = "git log";
    gm = "git checkout master";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    grc = "git rebase --continue";
    grm = "git rebase master";
    gs = "git status";

    ghco = "gh pr checkout";

    h = ''
      echo -e 'power on\nquit' | bluetoothctl;
      and sleep 2;
      and echo -e 'connect 70:26:05:DA:27:A4\nquit' | bluetoothctl;
      and sleep 5;
      and pactl set-default-sink "bluez_sink.70_26_05_DA_27_A4.a2dp_sink";
    '';
    halt = "shutdown now";

    k = "kubectl";
    kh = "prod-kubectl -n hyperion-staging";

    l = ''
      echo -e 'power off\nquit' | bluetoothctl;
      pactl set-default-sink "alsa_output.pci-0000_00_1f.3.analog-stereo"
    '';

    ll = "ls -l";

    logout = "i3-msg exit";

    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "sudo nixos-rebuild switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    p = "pactl upload-sample ~/Music/Own\\ Speech/IckbinArschratte.WAV ratte; and pactl play-sample ratte";

    "r+" = ''gh pr review --comment --body "bors r+"'';

    # Print timestamp along with cmd output
    # Example: cmd | ts
    ts = "gawk '{ print strftime(\"[%Y-%m-%d %H:%M:%S]\"), $0 }'";

    watch-lorri = "journalctl --user -eu lorri -f";

    x = "exit";
  };
}

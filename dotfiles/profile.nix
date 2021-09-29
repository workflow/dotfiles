{ pkgs }:

{
  path = [ "$HOME/bin" ];

  aliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    a = "autorandr --change";
    ab = "autorandr boar";
    am = "autorandr mobile";
    as = "autorandr single";
    av = "autorandr movie";

    aliases = "vim ~/nixos-config/dotfiles/profile.nix";

    c = "xclip -selection clipboard";

    cde = "cd ~/code/egghead/elm-ui";
    cdn = "cd ~/nixos-config";
    cdc = "cd ~/code";

    d = ''
      set DOCK "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo"
      echo -e 'power off\nquit' | bluetoothctl;
      pactl set-default-sink "$DOCK"
      set INPUTS (pactl list sink-inputs short | cut -f 1)
      for i in $INPUTS
        pactl move-sink-input $i "$DOCK"
      end
    '';
    da = "direnv allow";

    filters = "vim ~/.gmailctl/config.jsonnet";
    filtersp = "vim ~/.gmailctl/playbooks/config.jsonnet";
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
    gfo = "git fetch origin main:main";
    gfoo = "git fetch origin master:master";
    gl = "git log";
    gm = "git checkout main";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    grc = "git rebase --continue";
    grm = "git rebase master";
    gs = "git status";

    ghco = "gh pr checkout";

    gmailctlp = "gmailctl --config ~/.gmailctl/playbooks/";

    h = ''
      set HEADSET "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink"
      echo -e 'power on\nquit' | bluetoothctl;
      and sleep 2;
      and echo -e 'connect 14:3F:A6:28:DC:51\nquit' | bluetoothctl;
      and sleep 5;
      and pactl set-default-sink "$HEADSET";
      set INPUTS (pactl list sink-inputs short | cut -f 1)
      for i in $INPUTS
        pactl move-sink-input $i "$HEADSET"
      end
    '';
    halt = "shutdown now";

    k = "kubectl";

    l = ''
      set LOCAL "alsa_output.pci-0000_00_1f.3.analog-stereo"
      echo -e 'power off\nquit' | bluetoothctl;
      pactl set-default-sink "$LOCAL"
      set INPUTS (pactl list sink-inputs short | cut -f 1)
      for i in $INPUTS
        pactl move-sink-input $i "$LOCAL"
      end
    '';

    ll = "br -sdph";
    ls = "br -sdp";
    lh = "/run/current-system/sw/bin/ls -ah";

    logout = "i3-msg exit";

    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "sudo nixos-rebuild switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    p = "pactl upload-sample ~/Music/Own\\ Speech/IckbinArschratte.WAV ratte; and pactl play-sample ratte";

    pu = "pulsemixer";

    pk = "prod-kubectl";

    "r+" = ''gh pr review --comment --body "bors r+"'';

    soul = "nmcli c up 'Soul'";

    toshl2ynab = "cd ~/code/papasonprojects/csvfu/; and nix-shell --command 'python toshl2ynab.py'";

    # Print timestamp along with cmd output
    # Example: cmd | ts
    ts = "gawk '{ print strftime(\"[%Y-%m-%d %H:%M:%S]\"), $0 }'";

    w = "nohup webstorm &disown";
    watch-lorri = "journalctl --user -eu lorri -f";

    x = "exit";
  };
}

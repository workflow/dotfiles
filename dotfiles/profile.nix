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

    da = "direnv allow";

    ctnc = "cargo test -- --nocapture";
    ctnr = "cargo test --no-run";

    filters = "vim ~/.gmailctl/config.jsonnet";
    filtersp = "vim ~/.gmailctl/playbooks/config.jsonnet";
    freetapbeer = "nmcli c up 'Free Tap Beer'";

    g = "git";

    i = "vim ~/nixos-config/home/xsession/i3.nix";

    ga = "git add -p";
    gaa = "git add --all";
    gaf = "git add -N *";
    gc = "git checkout";
    gca = "git commit --amend";
    gcb = "git checkout -b";
    gd = "git diff";
    gdc = "git diff --cached";
    gf = "git fetch --prune";
    gfo = "git fetch origin main:main || git fetch origin master:master";
    gl = "git log";
    glcs = "git rev-parse HEAD | xclip -selection clipboard"; # Get Latest Commit SHA
    gm = "git checkout main || git checkout master";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    grc = "git rebase --continue";
    grm = "git rebase main || git rebase master";
    gs = "git status";

    ghco = "gh pr checkout";

    gmailctlp = "gmailctl --config ~/.gmailctl/playbooks/";

    halt = "shutdown now";

    k = "kubectl";

    llb = "br -sdph";
    lsb = "br -sdp";
    lh = "/run/current-system/sw/bin/ls -ah";

    logout = "i3-msg exit";

    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "sudo nixos-rebuild switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    p = "pactl upload-sample ~/Music/Own\\ Speech/IckbinArschratte.WAV ratte; and pactl play-sample ratte";

    paste = "xclip -selection c -o";

    pu = "pulsemixer";

    pk = "prod-kubectl";

    "r+" = ''gh pr review --comment --body "bors r+"'';

    soul = "nmcli c up 'Soul'";

    toshl2ynab = "cd ~/code/papasonprojects/csvfu/; and nix-shell --command 'python toshl2ynab.py'";

    tailup = "sudo tailscale up --accept-routes";
    taildown = "sudo tailscale down";

    # Print timestamp along with cmd output
    # Example: cmd | ts
    ts = "gawk '{ print strftime(\"[%Y-%m-%d %H:%M:%S]\"), $0 }'";

    w = "nohup webstorm &disown";
    watch-lorri = "journalctl --user -eu lorri -f";

    x = "exit";
  };
}

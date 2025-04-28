{...}: {
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    caffeinate = "systemctl --user stop swayidle";
    decaffeinate = "systemctl --user start swayidle";

    c = "wl-copy";
    cc = "tee /dev/tty | wl-copy";

    cdn = "cd ~/nixos-config";
    cdc = "cd ~/code";

    dira = "direnv allow";
    dird = "direnv deny";
    dirr = "direnv reload";
    dark-theme = "nh os test --no-specialisation";
    dr = "direnv reload";

    ga = "git add -p";
    gaa = "git add --all";
    gaf = "git add -N *";
    gc = "git checkout";
    gca = "git commit --amend";
    gcb = "git checkout -b";
    gcf = "git commit --fixup";
    gcm = "git commit -m";
    gd = "git diff";
    gdc = "git diff --cached";
    gf = "git fetch --prune";
    gfo = "git fetch origin main:main || git fetch origin master:master";
    gl = "git log";
    glcs = "git rev-parse HEAD | wl-copy"; # Get Latest Commit SHA
    gm = "git checkout main || git checkout master";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    grc = "git rebase --continue";
    grm = "git rebase main || git rebase master";
    gs = "git status";
    gst = "git stash";
    gsa = "git stash apply";
    gsp = "git stash pop";

    ghco = "gh pr checkout";
    ghpa = "gh pr review --approve";
    ghmr = "gh pr merge -r";

    k9s-kind = "k9s --context kind-kind";

    kc = "kubectl";
    kc-kind = "kubectl --context kind-kind";

    lh = "/run/current-system/sw/bin/ls -ah";
    light-theme = "nh os test --specialisation light";

    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "nh os switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    nsn = "nh search";

    pa = "pw-play ~/Music/Own\\ Speech/IckbinArschratte.WAV";

    paste = "wl-paste";

    ra = "systemctl restart --user pipewire";

    rm = "trash-put";

    stern-kind = "stern --context kind-kind";

    tailup = "sudo tailscale up --accept-routes --accept-dns=false";
    taildown = "sudo tailscale down";

    x = "exit";
  };
}

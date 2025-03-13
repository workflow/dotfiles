{...}: {
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    c = "wl-clip -selection clipboard";
    cc = "tee /dev/tty | wl-clip -selection clipboard";

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
    glcs = "git rev-parse HEAD | wl-clip -selection clipboard"; # Get Latest Commit SHA
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
    k9s-dlh = "k9s --context dlh-context";
    k9s-test = "k9s --context datamesh-test-cluster";
    k9s-prod = "k9s --context datamesh-prod-cluster";

    kc = "kubectl";
    kc-kind = "kubectl --context kind-kind";
    kc-dlh = "kubectl --context dlh-context";
    kc-test = "kubectl --context datamesh-test-cluster";
    kc-prod = "kubectl --context datamesh-prod-cluster";

    lh = "/run/current-system/sw/bin/ls -ah";
    light-theme = "nh os test --specialisation light";

    macgyver = "cd /home/farlion/code/dlh/common_scripts/setup_tools/sshforwarding; sudo python setup_forwarding.py";
    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "nh os switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    nsn = "nix search nixpkgs";

    pa = "pw-play ~/Music/Own\\ Speech/IckbinArschratte.WAV";

    paste = "wl-clip -selection c -o";

    ra = "systemctl restart --user pipewire";

    rm = "trash-put";

    soul = "nmcli c up 'Soul'";
    stern-kind = "stern --context kind-kind";
    stern-dlh = "stern --context dlh-context";
    stern-test = "stern --context datamesh-test-cluster";
    stern-prod = "stern --context datamesh-prod-cluster";

    tailup = "sudo tailscale up --accept-routes --accept-dns=false";
    taildown = "sudo tailscale down";

    x = "exit";
  };
}

{...}: {
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    as = "aichat --model openai:gpt-4o-mini-search-preview";
    ae = "aichat -e";

    caffeinate = "systemctl --user stop swayidle";
    decaffeinate = "systemctl --user start swayidle";

    c = "wl-copy";

    cdn = "cd ~/nixos-config";
    cdc = "cd ~/code";

    dira = "direnv allow";
    dird = "direnv deny";
    dirr = "direnv reload";
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
    gl = "git log";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    grc = "git rebase --continue";
    gs = "git status";
    gst = "git stash";
    gsa = "git stash apply";
    gsp = "git stash pop";

    ghco = "gh pr checkout";
    ghpa = "gh pr review --approve";
    ghmr = "gh pr merge -r";

    isdu = "isd --startup_mode=user";

    k9s-kind = "k9s --context kind-kind";

    kc = "kubectl";
    kc-kind = "kubectl --context kind-kind";

    lh = "/run/current-system/sw/bin/ls -ah";

    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "nh os switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    nsn = "nh search";

    paste = "wl-paste";

    ra = "systemctl restart --user pipewire";

    rm = "trash-put";

    stern-kind = "stern --context kind-kind";

    tailup = "sudo tailscale up --accept-routes --accept-dns=false";
    taildown = "sudo tailscale down";

    x = "exit";
  };
}

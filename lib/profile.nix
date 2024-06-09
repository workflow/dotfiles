{ pkgs }:

{
  path = [ "$HOME/bin" ];

  aliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    c = "xclip -selection clipboard";
    cc = "tee /dev/tty | xclip -selection clipboard";

    cdn = "cd ~/nixos-config";
    cdc = "cd ~/code";

    da = "direnv allow";
    dr = "direnv reload";

    ga = "git add -p";
    gaa = "git add --all";
    gaf = "git add -N *";
    gc = "git checkout";
    gca = "git commit --amend";
    gcb = "git checkout -b";
    gcf = "git commit --fixup";
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
    grim = "git rebase -i main || git rebase -i master";
    gs = "git status";
    gst = "git stash";
    gsa = "git stash apply";
    gsp = "git stash pop";

    ghco = "gh pr checkout";
    ghpa = "gh pr review --approve";
    ghmr = "gh pr merge -r";

    lh = "/run/current-system/sw/bin/ls -ah";

    macgyver = "cd /home/farlion/code/dlh/common_scripts/setup_tools/sshforwarding; sudo python setup_forwarding.py";
    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";

    n = "nh os switch";

    nl = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    ngc = "sudo nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system";

    nsn = "nix search nixpkgs";

    pa = "pw-play ~/Music/Own\\ Speech/IckbinArschratte.WAV";
    ra = "systemctl restart --user pipewire";

    paste = "xclip -selection c -o";

    rm = "trash-put";

    soul = "nmcli c up 'Soul'";

    tailup = "sudo tailscale up --accept-routes --accept-dns=false";
    taildown = "sudo tailscale down";

    x = "exit";
  };
}

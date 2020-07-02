{ pkgs }:

{
  #path = [ "$HOME/.local/bin" "$HOME/bin" ];
  aliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    c = "xclip -selection clipboard";
    da = "direnv allow";
    freetapbeer = "nmcli c up 'Free Tap Beer'";
    g = "git";

    # TODO: Move these to git aliases
    ga = "git add -p";
    gaa = "git add --all";
    gaf = "git add -N";
    gc = "git checkout";
    gca = "git commit --amend";
    gd = "git diff";
    gf = "git fetch --prune";
    gfo = "git fetch origin master:master";
    gl = "git log";
    gm = "git checkout master";
    gp = "git pull --prune";
    gpf = "git push --force-with-lease";
    gpn = "git push -u origin HEAD";
    gr = "git rebase";
    gs = "git status";

    k = "kubectl";
    ll = "ls -l";
    myip = "dig @resolver1.opendns.com ANY myip.opendns.com +short";
    watch-lorri = "journalctl --user -eu lorri -f";
    x = "exit";
  };
}

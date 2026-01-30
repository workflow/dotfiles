{...}: {
  flake.modules.homeManager.aliases = {...}: {
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
  };
}

{...}: let
  peon-ping-src = builtins.fetchTarball {
    url = "https://github.com/PeonPing/peon-ping/archive/60e2d9894edd22fa23b03d3d47956dbc0d781b32.tar.gz";
    sha256 = "sha256-Xud7UmYquVtANmSoJOFjx+HcYSogJ0JHruJfTEFc8as=";
  };

  og-packs-src = builtins.fetchTarball {
    url = "https://github.com/PeonPing/og-packs/archive/6970d159571aebbfc7457cb6a6cf2b764c8467e6.tar.gz";
    sha256 = "sha256-spao/GTIhH4c5HOmVc0umMvrwOaMRa4s5Pem1AWyUOw=";
  };

  defaultPacks = [
    "acolyte_de"
    "aoe2"
    "murloc"
    "peon"
    "peon_de"
  ];
in {
  flake.modules.homeManager.peon-ping = {
    pkgs,
    lib,
    ...
  }: let
    peon = pkgs.writeShellApplication {
      name = "peon";
      runtimeInputs = with pkgs; [
        python3
        curl
        libnotify
        pipewire
        procps
        coreutils
      ];
      runtimeEnv = {
        PEON_SCRIPT_PATH = "${peon-ping-src}/peon.sh";
      };
      text = builtins.readFile ./scripts/peon-wrapper.sh;
    };

    packSymlinks = lib.listToAttrs (map (name: {
        name = ".claude/hooks/peon-ping/packs/${name}";
        value = {source = "${og-packs-src}/${name}";};
      })
      defaultPacks);
  in {
    home.packages = [peon];

    home.file = packSymlinks;

    home.activation.seedPeonConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      peon_dir="$HOME/.claude/hooks/peon-ping"
      if [ ! -f "$peon_dir/config.json" ]; then
        mkdir -p "$peon_dir"
        cp "${peon-ping-src}/config.json" "$peon_dir/config.json"
        chmod 644 "$peon_dir/config.json"
      fi
    '';

    programs.claude-code.settings.hooks = let
      mkHook = event: {
        ${event} = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = "${peon}/bin/peon";
                timeout = 10;
              }
            ];
          }
        ];
      };
    in
      lib.mkMerge (map mkHook [
        "SessionStart"
        "UserPromptSubmit"
        "Stop"
        "Notification"
        "PermissionRequest"
      ]);
  };
}

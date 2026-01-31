{inputs, ...}: {
  flake.modules.homeManager.home-cleanup-todo = {
    config,
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    home.file."nixos-config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config";
      target = "nixos-config";
    };

    home.file.".config/home-manager/flake.nix" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/flake.nix";
    };

    home.packages = with pkgs; [
      alejandra
      ast-grep
      bc
      bind
      dconf
      difftastic
      dive
      dmidecode
      dnstracer
      efivar
      fast-cli
      fastfetch
      fd
      ffmpeg-full
      file
      find-cursor
      fortune
      glow
      gomatrix
      google-chrome
      gucharmap
      hardinfo2
      home-manager
      httpie
      iftop
      imagemagick
      iotop-c
      jq
      kind
      kdePackages.kruler
      lazydocker
      libnotify
      libsecret
      lm_sensors
      lolcat
      lsof
      ncdu
      nmap
      nethogs
      net-tools
      neo-cowsay
      nix-tree
      oculante
      kdePackages.okular
      openssl
      pdftk
      pstree
      q-text-as-data
      inputs.rmob.defaultPackage.x86_64-linux
      screenkey
      smartmontools
      s-tui
      stress
      tcpdump
      traceroute
      tree
      unzip
      usbutils
      wdisplays
      wf-recorder
      wget
      wireguard-tools
      whois
      wl-clipboard
      xournalpp
      yq
      yt-dlp
      zip
    ];

    home.sessionVariables =
      {
        PATH = "$HOME/bin:$PATH";
        NIXOS_CONFIG = "$HOME/code/nixos-config/";
        GC_INITIAL_HEAP_SIZE = "8G";
        DIRENV_LOG_FORMAT = "";
        NIXOS_OZONE_WL = "1";
      }
      // lib.optionalAttrs osConfig.dendrix.hasNvidia {
        LIBVA_DRIVER_NAME = "nvidia";
      };

    programs.bat = {
      enable = true;
    };

    programs.man = {
      enable = true;
      generateCaches = false;
    };

    programs.vscode = {
      enable = true;
    };
  };
}

{lib, ...}: {
  options.dendrix = {
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of this machine";
    };

    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is a laptop";
    };

    isImpermanent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this machine uses impermanence (ephemeral root)";
    };

    hasNvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this machine has an NVIDIA GPU";
    };

    hasAmd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this machine has an AMD GPU";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "NixOS state version for this host";
    };

    homeStateVersion = lib.mkOption {
      type = lib.types.str;
      description = "Home Manager state version for this host";
    };
  };
}

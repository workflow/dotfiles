{...}: {
  # opencode keeps sessions in a WAL-mode SQLite database that cannot be synced
  # as a file. Each host instead exports one JSON shard per session into its own
  # subdirectory of a Syncthing folder and imports the other hosts' shards with
  # session-level last-writer-wins. Known limits: use a session on one machine
  # at a time, deletes do not propagate, and sessions older than --days stop
  # being exported.
  flake.modules.homeManager.opencode-sync = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    opencode-session-sync = pkgs.python3Packages.buildPythonApplication {
      pname = "opencode-session-sync";
      version = "0.1.0";
      pyproject = true;
      src = ./src;
      build-system = [pkgs.python3Packages.setuptools];
      nativeCheckInputs = [pkgs.python3Packages.pytestCheckHook];
      meta.mainProgram = "opencode-session-sync";
    };
  in {
    home.packages = [opencode-session-sync];

    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/opencode-sync" # shards, shared via syncthing
        ".local/state/opencode-sync" # export/import bookkeeping
      ];
    };

    # The Syncthing folder root must exist before syncthing starts.
    systemd.user.tmpfiles.rules = [
      "d %h/.local/share/opencode-sync 0700 - - -"
      "d %h/.local/state/opencode-sync 0700 - - -"
    ];

    systemd.user.services.opencode-session-sync = {
      Unit.Description = "Export and import opencode session shards";
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe opencode-session-sync} sync --host ${osConfig.dendrix.hostname}";
      };
    };

    systemd.user.timers.opencode-session-sync = {
      Unit.Description = "Timer for opencode session shard sync";
      Timer = {
        OnBootSec = "2min";
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}

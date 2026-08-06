{...}: {
  # Shared shell permission lists for coding agents (claude-code, opencode).
  # Values are set in the secrets flake; empty defaults keep CI evaluable.
  flake.modules.homeManager.agent-permissions = {lib, ...}: {
    options.dendrix.agents = {
      shellAllowlist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Shell command prefixes agents may run without prompting";
      };
      shellDenylist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Shell command glob patterns agents must never run";
      };
    };
  };
}

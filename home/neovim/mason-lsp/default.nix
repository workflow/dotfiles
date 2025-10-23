{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/state/logrotate" # Logrotate state for nvim LSP logs
    ];
  };

  programs.neovim = {
    extraLuaConfig = ''
      -- LSP diagnostics: show inline virtual text
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        signs = true,          -- keep signs in the gutter
        underline = true,      -- underline offending code
        update_in_insert = false, -- reduce noise while typing
        severity_sort = true,  -- sort diagnostics by severity
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = mason-nvim; # Automatically install LSP servers
        config = builtins.readFile ./mason.lua;
        runtime = {
          "lua/shared_lsp_config.lua".source = ./shared_lsp_config.lua;
        };
        type = "lua";
      }
      {
        plugin = mason-lspconfig-nvim; # Automatically install LSP servers
      }
      {
        plugin = mason-nvim-dap-nvim; # Automatically configure DAP adapters
      }
    ];
  };

  # User-level logrotate for nvim LSP logs (hm doesn't support that yet)
  home.packages = [pkgs.logrotate];
  systemd.user.services.logrotate-nvim = {
    Unit = {
      Description = "Rotate nvim LSP log";
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir --parents %h/.local/state/logrotate";
      ExecStart = "${pkgs.logrotate}/bin/logrotate --state=%h/.local/state/logrotate/nvim.state %h/.config/logrotate/nvim.conf";
    };
  };
  systemd.user.timers.logrotate-nvim = {
    Unit = {
      Description = "Timer for nvim LSP log rotation";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
  home.file.".config/logrotate/nvim.conf".text = ''
    /home/farlion/.local/state/nvim/lsp.log {
      size 1M
      rotate 5
      compress
      copytruncate
      missingok
      notifempty
    }
  '';
}
